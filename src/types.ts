export type AppRole = 'user' | 'collector' | 'admin';

export interface UserProfile {
  uid: string;
  email: string;
  name: string;
  phone: string;
  role: AppRole;
  points: number;
  badges?: string[];
  referralCode: string;
  address: string;
  createdAt: any;
}

export type OrderStatus = 'pending' | 'accepted' | 'picked' | 'completed' | 'cancelled';

export interface ScrapOrder {
  id?: string;
  userId: string;
  collectorId?: string;
  status: OrderStatus;
  categories: string[];
  photoUrl?: string;
  estimatedPrice: number;
  finalPrice?: number;
  weight?: number;
  pickupAddress: string;
  createdAt: any;
  updatedAt?: any;
}

export interface ScrapPrice {
  id?: string;
  category: string;
  ratePerKg: number;
  unit: string;
}
