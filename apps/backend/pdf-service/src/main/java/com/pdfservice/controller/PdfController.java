package com.pdfservice.controller;

import com.pdfservice.service.PdfService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/pdf")
@CrossOrigin(origins = "*")
public class PdfController {

    @GetMapping("/")
    public ResponseEntity<Map<String, Object>> root() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "PDF Service API");
        response.put("version", "1.0.0");
        response.put("endpoints", new String[]{
            "GET /health - Health check",
            "POST /extract-text - Extract text from PDF",
            "POST /get-info - Get PDF information",
            "POST /merge - Merge multiple PDFs",
            "POST /split - Split PDF pages",
            "POST /add-watermark - Add watermark to PDF"
        });
        return ResponseEntity.ok(response);
    }

    @Autowired
    private PdfService pdfService;

    @GetMapping("/health")
    public ResponseEntity<Map<String, String>> healthCheck() {
        Map<String, String> response = new HashMap<>();
        response.put("status", "healthy");
        response.put("service", "pdf-service");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/extract-text")
    public ResponseEntity<Map<String, Object>> extractText(@RequestParam("file") MultipartFile file) {
        try {
            String extractedText = pdfService.extractText(file);
            Map<String, Object> response = new HashMap<>();
            response.put("text", extractedText);
            response.put("filename", file.getOriginalFilename());
            response.put("size", file.getSize());
            return ResponseEntity.ok(response);
        } catch (IOException e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Failed to extract text: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
        }
    }

    @PostMapping("/get-info")
    public ResponseEntity<Map<String, Object>> getPdfInfo(@RequestParam("file") MultipartFile file) {
        try {
            Map<String, Object> info = pdfService.getPdfInfo(file);
            return ResponseEntity.ok(info);
        } catch (IOException e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Failed to get PDF info: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
        }
    }

    @PostMapping("/merge")
    public ResponseEntity<byte[]> mergePdfs(@RequestParam("files") MultipartFile[] files) {
        try {
            byte[] mergedPdf = pdfService.mergePdfs(files);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDispositionFormData("attachment", "merged.pdf");
            
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(mergedPdf);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }

    @PostMapping("/split")
    public ResponseEntity<byte[]> splitPdf(
            @RequestParam("file") MultipartFile file,
            @RequestParam("startPage") int startPage,
            @RequestParam("endPage") int endPage) {
        try {
            byte[] splitPdf = pdfService.splitPdf(file, startPage, endPage);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDispositionFormData("attachment", "split.pdf");
            
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(splitPdf);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }

    @PostMapping("/add-watermark")
    public ResponseEntity<byte[]> addWatermark(
            @RequestParam("file") MultipartFile file,
            @RequestParam("watermarkText") String watermarkText) {
        try {
            byte[] watermarkedPdf = pdfService.addWatermark(file, watermarkText);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_PDF);
            headers.setContentDispositionFormData("attachment", "watermarked.pdf");
            
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(watermarkedPdf);
        } catch (IOException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }
}
