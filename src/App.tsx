/**
 * @license
 * SPDX-License-Identifier: Apache-2.0
 */

import React, { useState, useEffect } from 'react';
import { 
  onAuthStateChanged, 
  signInWithPopup, 
  GoogleAuthProvider, 
  signOut,
  User
} from 'firebase/auth';
import { 
  doc, 
  getDoc, 
  setDoc, 
  collection, 
  query, 
  where,
  orderBy, 
  onSnapshot,
  Timestamp,
  serverTimestamp,
  addDoc
} from 'firebase/firestore';
import { 
  Recycle, 
  Plus, 
  History, 
  User as UserIcon, 
  Trophy, 
  Wallet, 
  ChevronRight, 
  Camera, 
  MapPin, 
  Clock,
  LogOut,
  Bell,
  Star,
  Gift,
  Share2,
  Trash2,
  Truck
} from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { auth, db, handleFirestoreError, OperationType } from './lib/firebase';
import { cn, formatCurrency } from './lib/utils';
import { UserProfile, ScrapOrder, ScrapPrice, AppRole } from './types';
import { estimateScrapPrice } from './services/geminiService';

// Placeholder for screens
type Screen = 'home' | 'book' | 'history' | 'wallet' | 'profile' | 'leaderboard';

export default function App() {
  const [user, setUser] = useState<User | null>(null);
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [loading, setLoading] = useState(true);
  const [activeScreen, setActiveScreen] = useState<Screen>('home');
  const [orders, setOrders] = useState<ScrapOrder[]>([]);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, async (firebaseUser) => {
      setUser(firebaseUser);
      if (firebaseUser) {
        // Fetch profile
        try {
          const profileDoc = await getDoc(doc(db, 'users', firebaseUser.uid));
          if (profileDoc.exists()) {
            setProfile(profileDoc.data() as UserProfile);
          } else {
            // Create profile
            const newProfile: UserProfile = {
              uid: firebaseUser.uid,
              email: firebaseUser.email || '',
              name: firebaseUser.displayName || 'User',
              phone: '',
              role: 'user',
              points: 0,
              badges: ['Eco Starter'],
              referralCode: Math.random().toString(36).substring(2, 8).toUpperCase(),
              address: '',
              createdAt: serverTimestamp()
            };
            await setDoc(doc(db, 'users', firebaseUser.uid), newProfile);
            setProfile(newProfile);
          }
        } catch (error) {
          handleFirestoreError(error, OperationType.GET, `users/${firebaseUser.uid}`);
        }
      } else {
        setProfile(null);
      }
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  useEffect(() => {
    if (user) {
      const q = query(
        collection(db, 'orders'), 
        where('userId', '==', user.uid),
        orderBy('createdAt', 'desc')
      );
      const unsubscribe = onSnapshot(q, (snapshot) => {
        const orderList = snapshot.docs
          .map(doc => ({ id: doc.id, ...doc.data() } as ScrapOrder));
        setOrders(orderList);
      }, (error) => {
        handleFirestoreError(error, OperationType.LIST, 'orders');
      });
      return () => unsubscribe();
    }
  }, [user]);

  const handleLogin = async () => {
    const provider = new GoogleAuthProvider();
    setErrorMessage(null);
    try {
      await signInWithPopup(auth, provider);
    } catch (error: any) {
      if (error.code === 'auth/popup-closed-by-user') {
        setErrorMessage("Login window was closed. Please try again.");
      } else {
        setErrorMessage("An error occurred during login. Please try again.");
        console.error("Login Error", error);
      }
    }
  };

  if (loading) {
    return (
      <div className="h-screen w-full flex items-center justify-center bg-green-50">
        <motion.div 
          animate={{ rotate: 360 }}
          transition={{ repeat: Infinity, duration: 1, ease: 'linear' }}
        >
          <Recycle className="h-10 w-10 text-green-600" />
        </motion.div>
      </div>
    );
  }

  if (!user) {
    return (
      <div className="h-screen w-full max-w-md mx-auto bg-white flex flex-col p-6">
        <div className="flex-1 flex flex-col items-center justify-center space-y-8">
          <div className="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center">
            <Recycle className="h-12 w-12 text-green-600" />
          </div>
          <div className="text-center space-y-2">
            <h1 className="text-3xl font-bold text-gray-900 font-sans tracking-tight">Vangari - ভাঙারি</h1>
            <p className="text-gray-500">Recycle smart, earn cash, save the environment.</p>
          </div>
          
          <div className="w-full space-y-4">
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={handleLogin}
              className="w-full py-4 bg-green-600 text-white rounded-2xl font-bold text-lg shadow-lg shadow-green-200 flex items-center justify-center gap-2"
            >
              Sign In with Google
              <ChevronRight className="h-5 w-5" />
            </motion.button>

            {errorMessage && (
              <motion.p 
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="text-center text-sm font-medium text-red-500 bg-red-50 p-3 rounded-xl border border-red-100"
              >
                {errorMessage}
              </motion.p>
            )}
          </div>
        </div>
        <p className="text-center text-xs text-gray-400">
          By continuing, you agree to our Terms and Service.
        </p>
      </div>
    );
  }

  const renderScreen = () => {
    switch (activeScreen) {
      case 'home': return <HomeScreen profile={profile} orders={orders} onBook={() => setActiveScreen('book')} />;
      case 'book': return <BookPickupScreen profile={profile} onComplete={() => setActiveScreen('home')} onCancel={() => setActiveScreen('home')} />;
      case 'history': return <HistoryScreen orders={orders} />;
      case 'wallet': return <WalletScreen profile={profile} />;
      case 'profile': return <ProfileScreen profile={profile} onLogout={() => signOut(auth)} />;
      case 'leaderboard': return <LeaderboardScreen />;
      default: return <HomeScreen profile={profile} orders={orders} onBook={() => setActiveScreen('book')} />;
    }
  };

  return (
    <div className="h-screen w-full max-w-md mx-auto bg-gray-50 flex flex-col relative overflow-hidden font-sans">
      <div className="flex-1 overflow-y-auto pb-24">
        {renderScreen()}
      </div>

      {/* Bottom Nav */}
      <div className="absolute bottom-0 left-0 right-0 h-20 bg-white border-t border-gray-100 flex items-center justify-around px-2 shadow-2xl z-50">
        <NavButton active={activeScreen === 'home'} icon={<Recycle />} label="Home" onClick={() => setActiveScreen('home')} />
        <NavButton active={activeScreen === 'history'} icon={<History />} label="Activities" onClick={() => setActiveScreen('history')} />
        <div className="-mt-12">
          <button 
            onClick={() => setActiveScreen('book')}
            className="w-16 h-16 bg-green-600 rounded-full flex items-center justify-center text-white shadow-xl shadow-green-100 transform active:scale-90 transition-transform"
          >
            <Plus className="h-8 w-8" />
          </button>
        </div>
        <NavButton active={activeScreen === 'wallet'} icon={<Wallet />} label="Wallet" onClick={() => setActiveScreen('wallet')} />
        <NavButton active={activeScreen === 'profile'} icon={<UserIcon />} label="Profile" onClick={() => setActiveScreen('profile')} />
      </div>
    </div>
  );
}

function NavButton({ active, icon, label, onClick }: { active: boolean, icon: React.ReactNode, label: string, onClick: () => void }) {
  return (
    <button 
      onClick={onClick}
      className={cn(
        "flex flex-col items-center space-y-1 transition-colors",
        active ? "text-green-600" : "text-gray-400"
      )}
    >
      {React.cloneElement(icon as React.ReactElement, { className: "h-6 w-6" })}
      <span className="text-[10px] font-medium">{label}</span>
    </button>
  );
}

// --- Sub-Screens ---

function HomeScreen({ profile, orders, onBook }: { profile: UserProfile | null, orders: ScrapOrder[], onBook: () => void }) {
  const pendingOrders = orders.filter(o => o.status === 'pending' || o.status === 'accepted');
  
  return (
    <div className="p-6 space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-gray-500 text-sm">Welcome back,</p>
          <h2 className="text-2xl font-bold text-gray-900">{profile?.name} 👋</h2>
        </div>
        <div className="relative">
          <Bell className="h-6 w-6 text-gray-400" />
          <span className="absolute -top-1 -right-1 w-2 h-2 bg-red-500 rounded-full border-2 border-white"></span>
        </div>
      </div>

      {/* Points Card */}
      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-green-600 rounded-3xl p-6 text-white shadow-xl shadow-green-100 flex items-center justify-between overflow-hidden relative"
      >
        <div className="relative z-10">
          <p className="text-green-100 text-sm font-medium">Eco Balance</p>
          <p className="text-3xl font-bold mt-1">{formatCurrency(profile?.points || 0)}</p>
          <div className="mt-4 flex items-center gap-2 bg-green-500/30 px-3 py-1 rounded-full text-xs w-max">
            <Trophy className="h-3 w-3" />
            <span>Top 5% in Dhaka</span>
          </div>
        </div>
        <div className="relative z-10 text-right">
          <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center backdrop-blur-md">
            <Gift className="h-8 w-8" />
          </div>
        </div>
        {/* Background blobs */}
        <div className="absolute -bottom-10 -right-10 w-40 h-40 bg-white/10 rounded-full blur-2xl"></div>
        <div className="absolute -top-10 -left-10 w-40 h-40 bg-green-400/20 rounded-full blur-2xl"></div>
      </motion.div>

      {/* Statistics Row */}
      <div className="grid grid-cols-2 gap-4">
        <div className="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm flex items-center gap-3">
          <div className="w-10 h-10 bg-blue-50 rounded-xl flex items-center justify-center text-blue-600">
            <Truck className="h-5 w-5" />
          </div>
          <div>
            <p className="text-[10px] text-gray-500 uppercase tracking-wider font-bold">Pickups</p>
            <p className="text-lg font-bold">{orders.filter(o => o.status === 'completed').length}</p>
          </div>
        </div>
        <div className="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm flex items-center gap-3">
          <div className="w-10 h-10 bg-orange-50 rounded-xl flex items-center justify-center text-orange-600">
            <Trash2 className="h-5 w-5" />
          </div>
          <div>
            <p className="text-[10px] text-gray-500 uppercase tracking-wider font-bold">Recycled</p>
            <p className="text-lg font-bold">12 kg</p>
          </div>
        </div>
      </div>

      {/* Active Tracking */}
      {pendingOrders.length > 0 && (
        <div className="space-y-3">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-bold">Active Trackings</h3>
            <button className="text-green-600 text-sm font-bold">See all</button>
          </div>
          {pendingOrders.map(order => (
            <div key={order.id} className="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm space-y-3">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-8 h-8 bg-green-50 rounded-lg flex items-center justify-center text-green-600">
                    <Clock className="h-4 w-4" />
                  </div>
                  <span className="text-sm font-bold text-gray-700 capitalize">{order.status}</span>
                </div>
                <span className="text-xs text-gray-400">Order #{order.id?.slice(-4)}</span>
              </div>
              <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                <motion.div 
                  initial={{ width: 0 }}
                  animate={{ width: order.status === 'pending' ? '25%' : '75%' }}
                  className="h-full bg-green-500"
                ></motion.div>
              </div>
              <div className="flex items-center justify-between text-[11px] text-gray-500 font-medium">
                <span>Requested</span>
                <span>On the way</span>
                <span>Picked</span>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* Promo Banner */}
      <div className="bg-yellow-50 rounded-2xl p-4 border border-yellow-100 flex items-center gap-4">
        <div className="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center text-yellow-600">
          <Share2 className="h-6 w-6" />
        </div>
        <div className="flex-1">
          <p className="text-sm font-bold text-gray-900">Invite & Earn ৳50</p>
          <p className="text-xs text-gray-500">Send invite to your neighbor in apartment.</p>
        </div>
        <button className="bg-yellow-500 text-white px-3 py-1.5 rounded-lg text-xs font-bold">Invite</button>
      </div>

      {/* Categories */}
      <div className="space-y-3">
        <h3 className="text-lg font-bold">Scrap Categories</h3>
        <div className="grid grid-cols-4 gap-4">
          <CategoryBtn icon="📄" label="Paper" />
          <CategoryBtn icon="🥤" label="Plastic" />
          <CategoryBtn icon="🧱" label="Iron" />
          <CategoryBtn icon="💻" label="E-waste" />
        </div>
      </div>
    </div>
  );
}

function CategoryBtn({ icon, label }: { icon: string, label: string }) {
  return (
    <div className="flex flex-col items-center gap-2">
      <div className="w-full aspect-square bg-white border border-gray-100 rounded-2xl flex items-center justify-center text-2xl shadow-sm">
        {icon}
      </div>
      <span className="text-[10px] font-bold text-gray-600">{label}</span>
    </div>
  );
}

function BookPickupScreen({ profile, onComplete, onCancel }: { profile: UserProfile | null, onComplete: () => void, onCancel: () => void }) {
  const [step, setStep] = useState(1);
  const [photo, setPhoto] = useState<string | null>(null);
  const [estimation, setEstimation] = useState<any>(null);
  const [loading, setLoading] = useState(false);
  const [address, setAddress] = useState(profile?.address || '');

  const handlePhotoUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = async () => {
        const base64 = (reader.result as string).split(',')[1];
        setPhoto(reader.result as string);
        setLoading(true);
        const result = await estimateScrapPrice(base64);
        setEstimation(result);
        setLoading(false);
        setStep(2);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSubmit = async () => {
    if (!auth.currentUser || !profile) return;
    try {
      setLoading(true);
      await addDoc(collection(db, 'orders'), {
        userId: profile.uid,
        status: 'pending',
        categories: estimation?.categories || [],
        estimatedPrice: estimation?.estimatedValueBDT || 0,
        pickupAddress: address,
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp()
      });
      onComplete();
    } catch (error) {
       console.error("Order Submit Error", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-6 space-y-6">
      <div className="flex items-center gap-4">
        <button onClick={onCancel} className="w-10 h-10 bg-white border border-gray-100 rounded-xl flex items-center justify-center text-gray-600">
          <ChevronRight className="h-5 w-5 transform rotate-180" />
        </button>
        <h2 className="text-xl font-bold text-gray-900">Book Pickup</h2>
      </div>

      {step === 1 && (
        <div className="space-y-6">
          <div className="bg-green-50 border-2 border-dashed border-green-200 rounded-3xl p-8 flex flex-col items-center justify-center text-center space-y-4">
            <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center text-green-600">
              <Camera className="h-8 w-8" />
            </div>
            <div>
              <p className="font-bold text-green-900">Take a photo of your scrap</p>
              <p className="text-sm text-green-600/70">Our AI will estimate the price instantly.</p>
            </div>
            <label className="bg-green-600 text-white px-6 py-3 rounded-xl font-bold shadow-lg shadow-green-200 cursor-pointer">
              Upload Photo
              <input type="file" accept="image/*" className="hidden" onChange={handlePhotoUpload} />
            </label>
          </div>

          <div className="bg-white p-6 rounded-3xl border border-gray-100 shadow-sm space-y-4">
            <h3 className="font-bold flex items-center gap-2">
              <MapPin className="h-4 w-4 text-green-600" />
              Pickup Address
            </h3>
            <textarea 
              value={address}
              onChange={(e) => setAddress(e.target.value)}
              className="w-full h-24 bg-gray-50 rounded-xl p-4 text-sm border-0 focus:ring-2 focus:ring-green-500"
              placeholder="House #, Road #, Area..."
            />
          </div>
        </div>
      )}

      {step === 2 && (
        <div className="space-y-6">
          <div className="relative aspect-video rounded-3xl overflow-hidden bg-gray-200 shadow-inner">
            <img src={photo || ''} className="w-full h-full object-cover" alt="Scrap" />
            {loading && (
              <div className="absolute inset-0 bg-black/40 backdrop-blur-sm flex items-center justify-center text-white flex-col gap-2">
                <motion.div animate={{ rotate: 360 }} transition={{ repeat: Infinity, duration: 1, ease: 'linear' }}>
                  <Recycle className="h-8 w-8" />
                </motion.div>
                <p className="text-xs font-bold uppercase tracking-widest">AI Estimating...</p>
              </div>
            )}
          </div>

          <AnimatePresence>
            {!loading && estimation && (
              <motion.div 
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                className="bg-white p-6 rounded-3xl border border-green-100 shadow-sm space-y-4"
              >
                <div className="flex items-center justify-between">
                  <span className="text-sm text-gray-500">Estimated Value</span>
                  <span className="text-2xl font-black text-green-600">{formatCurrency(estimation.estimatedValueBDT)}</span>
                </div>
                <div className="grid grid-cols-2 gap-3">
                  <div className="p-3 bg-gray-50 rounded-xl">
                    <p className="text-[10px] text-gray-400 uppercase font-bold">Categories</p>
                    <p className="text-sm font-bold text-gray-700">{estimation.categories.join(', ')}</p>
                  </div>
                  <div className="p-3 bg-gray-50 rounded-xl">
                    <p className="text-[10px] text-gray-400 uppercase font-bold">Est. Weight</p>
                    <p className="text-sm font-bold text-gray-700">{estimation.estimatedWeightKg} kg</p>
                  </div>
                </div>
                <p className="text-xs text-gray-500 italic">"{estimation.description}"</p>
              </motion.div>
            )}
          </AnimatePresence>

          <button 
            disabled={loading}
            onClick={handleSubmit}
            className="w-full py-4 bg-green-600 text-white rounded-2xl font-bold shadow-lg shadow-green-200 disabled:opacity-50"
          >
            Confirm & Schedule Pickup
          </button>
          <button 
            onClick={() => setStep(1)}
            className="w-full py-4 text-gray-500 font-bold"
          >
            Retake Photo
          </button>
        </div>
      )}
    </div>
  );
}

function HistoryScreen({ orders }: { orders: ScrapOrder[] }) {
  return (
    <div className="p-6 space-y-6">
       <h2 className="text-2xl font-bold text-gray-900">Activities</h2>
       {orders.length === 0 ? (
         <div className="flex flex-col items-center justify-center py-20 text-gray-400 gap-4">
            <History className="h-12 w-12 opacity-20" />
            <p>No activity yet.</p>
         </div>
       ) : (
         <div className="space-y-4">
            {orders.map(order => (
              <div key={order.id} className="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm flex items-center justify-between">
                <div className="flex items-center gap-4">
                   <div className={cn(
                     "w-12 h-12 rounded-xl flex items-center justify-center",
                     order.status === 'completed' ? "bg-green-50 text-green-600" : "bg-orange-50 text-orange-600"
                   )}>
                      {order.status === 'completed' ? <Gift className="h-6 w-6" /> : <Clock className="h-6 w-6" />}
                   </div>
                   <div>
                      <p className="font-bold text-sm text-gray-900">{order.categories.join(', ') || 'Mixed Scrap'}</p>
                      <p className="text-xs text-gray-400">
                        {order.createdAt?.seconds 
                          ? new Date(order.createdAt.seconds * 1000).toLocaleDateString() 
                          : 'Just now'}
                      </p>
                   </div>
                </div>
                <div className="text-right">
                   <p className="font-bold text-gray-900">{formatCurrency(order.finalPrice || order.estimatedPrice)}</p>
                   <p className={cn(
                     "text-[10px] font-bold uppercase",
                     order.status === 'completed' ? "text-green-500" : "text-orange-500"
                   )}>{order.status}</p>
                </div>
              </div>
            ))}
         </div>
       )}
    </div>
  );
}

function WalletScreen({ profile }: { profile: UserProfile | null }) {
  return (
    <div className="p-6 space-y-6">
       <h2 className="text-2xl font-bold text-gray-900">Wallet</h2>
       
       <div className="bg-gradient-to-br from-gray-900 to-gray-800 rounded-3xl p-6 text-white shadow-xl relative overflow-hidden">
          <div className="relative z-10">
            <p className="text-gray-400 text-sm font-medium">Available for Payout</p>
            <p className="text-4xl font-bold mt-2 font-mono">৳{(profile?.points || 0).toLocaleString()}</p>
            <div className="mt-8 flex gap-4">
              <button className="bg-white text-gray-900 px-6 py-2 rounded-xl font-bold text-sm">Payout</button>
              <button className="bg-white/10 text-white px-6 py-2 rounded-xl font-bold text-sm backdrop-blur-md">Transactions</button>
            </div>
          </div>
          <div className="absolute top-[-20%] right-[-10%] w-64 h-64 bg-green-500/20 rounded-full blur-3xl"></div>
       </div>

       <div className="space-y-4">
          <h3 className="font-bold text-gray-900">Reward Options</h3>
          <RewardItem icon={<Gift className="text-blue-500" />} label="bKash Transfer" desc="Instant payout to bKash" />
          <RewardItem icon={<Gift className="text-orange-500" />} label="Nagad Transfer" desc="Payout to your Nagad wallet" />
          <RewardItem icon={<Gift className="text-green-500" />} label="Charity" desc="Donate your earnings to Eco Foundation" />
       </div>
    </div>
  );
}

function RewardItem({ icon, label, desc }: { icon: React.ReactNode, label: string, desc: string }) {
  return (
    <div className="bg-white p-4 rounded-2xl border border-gray-100 shadow-sm flex items-center justify-between group cursor-pointer hover:border-green-200 transition-colors">
       <div className="flex items-center gap-4">
          <div className="w-12 h-12 bg-gray-50 rounded-xl flex items-center justify-center">
            {icon}
          </div>
          <div>
            <p className="font-bold text-gray-900">{label}</p>
            <p className="text-xs text-gray-400">{desc}</p>
          </div>
       </div>
       <ChevronRight className="h-5 w-5 text-gray-300 group-hover:text-green-500" />
    </div>
  );
}

function ProfileScreen({ profile, onLogout }: { profile: UserProfile | null, onLogout: () => void }) {
  return (
    <div className="p-6 space-y-8">
       <div className="flex flex-col items-center gap-4 pt-10">
          <div className="w-24 h-24 bg-green-100 rounded-full flex items-center justify-center text-green-600 border-4 border-white shadow-xl relative">
             <UserIcon className="h-10 w-10" />
             <div className="absolute bottom-0 right-0 w-8 h-8 bg-green-500 rounded-full border-4 border-white flex items-center justify-center text-white">
                <Star className="h-4 w-4 fill-current" />
             </div>
          </div>
          <div className="text-center">
             <h3 className="text-xl font-bold text-gray-900">{profile?.name}</h3>
          </div>
       </div>

       {/* Badges Section */}
       <div className="space-y-3">
          <h4 className="text-[10px] text-gray-400 uppercase font-black tracking-widest px-4">Achievements</h4>
          <div className="flex flex-wrap gap-2 px-2">
             {profile?.badges?.map((badge, idx) => (
                <motion.div 
                  key={idx}
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  whileHover={{ y: -5 }}
                  className="bg-white border border-gray-100 rounded-2xl px-4 py-2 flex items-center gap-2 shadow-sm"
                >
                   <div className="w-6 h-6 bg-yellow-100 rounded-full flex items-center justify-center text-[10px]">🏆</div>
                   <span className="text-xs font-bold text-gray-700">{badge}</span>
                </motion.div>
             ))}
             {!profile?.badges?.length && (
                <p className="text-xs text-gray-400 px-2">Start recycling to earn badges!</p>
             )}
          </div>
       </div>

       <div className="space-y-2">
          <h4 className="text-[10px] text-gray-400 uppercase font-black tracking-widest px-4">Account Settings</h4>
          <div className="bg-white rounded-3xl border border-gray-100 overflow-hidden divide-y divide-gray-50 shadow-sm">
             <ProfileLink icon={<UserIcon className="text-blue-500" />} label="Edit Profile" />
             <ProfileLink icon={<MapPin className="text-red-500" />} label="Saved Addresses" />
             <ProfileLink icon={<Share2 className="text-purple-500" />} label="Referral Code" sub={profile?.referralCode} />
             <ProfileLink icon={<Bell className="text-yellow-500" />} label="Notifications" />
          </div>
       </div>

       <button 
        onClick={onLogout}
        className="w-full py-4 bg-red-50 text-red-500 rounded-2xl font-bold flex items-center justify-center gap-2"
       >
         <LogOut className="h-5 w-5" />
         Logout
       </button>
    </div>
  );
}

function ProfileLink({ icon, label, sub }: { icon: React.ReactNode, label: string, sub?: string }) {
  return (
    <div className="p-4 flex items-center justify-between hover:bg-gray-50 cursor-pointer">
       <div className="flex items-center gap-4">
          <div className="w-10 h-10 bg-gray-50 rounded-xl flex items-center justify-center">
            {React.cloneElement(icon as React.ReactElement, { className: "h-5 w-5" })}
          </div>
          <span className="font-bold text-gray-700 text-sm">{label}</span>
       </div>
       <div className="flex items-center gap-2">
          {sub && <span className="text-xs font-mono font-bold text-green-600 bg-green-50 px-2 py-1 rounded-md">{sub}</span>}
          <ChevronRight className="h-4 w-4 text-gray-300" />
       </div>
    </div>
  );
}

function LeaderboardScreen() {
  return <div>Leaderboard coming soon</div>;
}
