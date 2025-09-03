package com.pdfservice.service;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.Standard14Fonts;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.util.Matrix;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Service
public class PdfService {

    public String extractText(MultipartFile file) throws IOException {
        try (PDDocument document = Loader.loadPDF(file.getBytes())) {
            PDFTextStripper stripper = new PDFTextStripper();
            return stripper.getText(document);
        }
    }

    public Map<String, Object> getPdfInfo(MultipartFile file) throws IOException {
        Map<String, Object> info = new HashMap<>();
        
        try (PDDocument document = Loader.loadPDF(file.getBytes())) {
            info.put("pageCount", document.getNumberOfPages());
            info.put("encrypted", document.isEncrypted());
            info.put("filename", file.getOriginalFilename());
            info.put("size", file.getSize());
            
            // Get document information if available
            if (document.getDocumentInformation() != null) {
                info.put("title", document.getDocumentInformation().getTitle());
                info.put("author", document.getDocumentInformation().getAuthor());
                info.put("subject", document.getDocumentInformation().getSubject());
                info.put("creator", document.getDocumentInformation().getCreator());
                info.put("producer", document.getDocumentInformation().getProducer());
                info.put("creationDate", document.getDocumentInformation().getCreationDate());
                info.put("modificationDate", document.getDocumentInformation().getModificationDate());
            }
        }
        
        return info;
    }

    public byte[] mergePdfs(MultipartFile[] files) throws IOException {
        try (PDDocument mergedDocument = new PDDocument()) {
            
            for (MultipartFile file : files) {
                try (PDDocument document = Loader.loadPDF(file.getBytes())) {
                    for (int i = 0; i < document.getNumberOfPages(); i++) {
                        mergedDocument.addPage(document.getPage(i));
                    }
                }
            }
            
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            mergedDocument.save(outputStream);
            return outputStream.toByteArray();
        }
    }

    public byte[] splitPdf(MultipartFile file, int startPage, int endPage) throws IOException {
        try (PDDocument originalDocument = Loader.loadPDF(file.getBytes());
             PDDocument splitDocument = new PDDocument()) {
            
            // Validate page numbers
            if (startPage < 1 || endPage > originalDocument.getNumberOfPages() || startPage > endPage) {
                throw new IllegalArgumentException("Invalid page range");
            }
            
            // Add pages to split document (convert to 0-based indexing)
            for (int i = startPage - 1; i < endPage; i++) {
                splitDocument.addPage(originalDocument.getPage(i));
            }
            
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            splitDocument.save(outputStream);
            return outputStream.toByteArray();
        }
    }

    public byte[] addWatermark(MultipartFile file, String watermarkText) throws IOException {
        try (PDDocument document = Loader.loadPDF(file.getBytes())) {
            
            for (int i = 0; i < document.getNumberOfPages(); i++) {
                PDPage page = document.getPage(i);
                
                try (PDPageContentStream contentStream = new PDPageContentStream(
                        document, page, PDPageContentStream.AppendMode.APPEND, true, true)) {
                    
                    // Set font and size
                    contentStream.setFont(new PDType1Font(Standard14Fonts.FontName.HELVETICA), 48);
                    contentStream.setNonStrokingColor(200, 200, 200); // Light gray
                    
                    // Calculate position for watermark (center of page)
                    float pageWidth = page.getMediaBox().getWidth();
                    float pageHeight = page.getMediaBox().getHeight();
                    
                    // Get text width to center it
                    float textWidth = new PDType1Font(Standard14Fonts.FontName.HELVETICA).getStringWidth(watermarkText) / 1000 * 48;
                    float x = (pageWidth - textWidth) / 2;
                    float y = pageHeight / 2;
                    
                    // Rotate and position text
                    contentStream.beginText();
                    contentStream.setTextMatrix(Matrix.getRotateInstance(Math.toRadians(45), x, y));
                    contentStream.showText(watermarkText);
                    contentStream.endText();
                }
            }
            
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            document.save(outputStream);
            return outputStream.toByteArray();
        }
    }
}
