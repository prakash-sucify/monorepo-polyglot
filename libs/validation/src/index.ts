import Joi from 'joi';
import { z } from 'zod';

// Common validation schemas
export const emailSchema = Joi.string().email().required();
export const passwordSchema = Joi.string().min(8).pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/).required();

// User validation schemas
export const userRegistrationSchema = Joi.object({
  email: emailSchema,
  password: passwordSchema,
  firstName: Joi.string().min(2).max(50).required(),
  lastName: Joi.string().min(2).max(50).required(),
});

export const userLoginSchema = Joi.object({
  email: emailSchema,
  password: Joi.string().required(),
});

// Payment validation schemas
export const paymentSchema = Joi.object({
  amount: Joi.number().positive().required(),
  currency: Joi.string().length(3).uppercase().required(),
  description: Joi.string().max(500).optional(),
  customerId: Joi.string().required(),
});

// Analytics validation schemas
export const eventSchema = Joi.object({
  eventType: Joi.string().required(),
  userId: Joi.string().optional(),
  properties: Joi.object().optional(),
  timestamp: Joi.date().iso().optional(),
});

// Zod schemas for frontend validation
export const userRegistrationZodSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).regex(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/),
  firstName: z.string().min(2).max(50),
  lastName: z.string().min(2).max(50),
});

export const userLoginZodSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
});

export const paymentZodSchema = z.object({
  amount: z.number().positive(),
  currency: z.string().length(3).toUpperCase(),
  description: z.string().max(500).optional(),
  customerId: z.string(),
});

// Validation utility functions
export const validateEmail = (email: string): boolean => {
  return emailSchema.validate(email).error === undefined;
};

export const validatePassword = (password: string): boolean => {
  return passwordSchema.validate(password).error === undefined;
};

export const validateUserRegistration = (data: any) => {
  return userRegistrationSchema.validate(data);
};

export const validateUserLogin = (data: any) => {
  return userLoginSchema.validate(data);
};

export const validatePayment = (data: any) => {
  return paymentSchema.validate(data);
};

export const validateEvent = (data: any) => {
  return eventSchema.validate(data);
};
