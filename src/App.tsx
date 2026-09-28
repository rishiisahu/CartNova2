import React, { useState } from 'react';
import { 
  ShoppingBag, Search, User as UserIcon, LogOut, CheckCircle2, 
  Truck, ShieldCheck, RotateCcw, Headset, Star, ArrowRight, 
  Menu, X, Sparkles, PlusCircle, LayoutDashboard, Receipt, Tag,
  Camera, Edit3, Trash2, ArrowUpDown, Filter, RotateCcw as ResetIcon,
  ChevronDown, Check, AlertTriangle, ArrowLeft, Bolt, Minus, Plus,
  Eye, EyeOff, Lock, Mail, Phone, ShieldAlert, KeyRound, UserCheck, 
  LogIn, CheckCircle, HelpCircle, Shield
} from 'lucide-react';

interface ProductItem {
  id: number;
  name: string;
  category: string;
  price: number;
  originalPrice: number;
  discount: number;
  stock: number;
  sellerId: number;
  seller: string;
  rating: number;
  reviews: number;
  image: string;
  gallery: string[];
  description: string;
}

interface CartItemData {
  id: number;
  product: ProductItem;
  quantity: number;
}

interface OrderItemData {
  productId: number;
  productName: string;
  price: number;
  quantity: number;
  subtotal: number;
  image: string;
}

interface OrderData {
  orderId: number;
  customerName: string;
  phone: string;
  address: string;
  city: string;
  state: string;
  postalCode: string;
  subtotal: number;
  shipping: number;
  tax: number;
  grandTotal: number;
  orderStatus: string;
  paymentStatus: string;
  orderDate: string;
  items: OrderItemData[];
}

const INITIAL_PRODUCTS: ProductItem[] = [
  {
    id: 1,
    name: 'Sony WH-1000XM5 Wireless Noise Cancelling Headphones',
    category: 'Audio',
    price: 314,
    originalPrice: 349,
    discount: 10,
    stock: 25,
    sellerId: 1,
    seller: 'Demo Seller',
    rating: 4.9,
    reviews: 142,
    image: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
    gallery: [
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=600&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=600&auto=format&fit=crop&q=80'
    ],
    description: 'Industry-leading noise cancellation with two processors and 8 microphones for unprecedented sound quality. Features up to 30 hours of battery life with quick charge, multipoint Bluetooth connection, and ultra-comfortable lightweight design.'
  },
  {
    id: 2,
    name: 'Apple Watch Series 9 GPS 45mm Starlight Aluminium',
    category: 'Wearables',
    price: 407,
    originalPrice: 429,
    discount: 5,
    stock: 18,
    sellerId: 1,
    seller: 'Demo Seller',
    rating: 4.8,
    reviews: 98,
    image: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
    gallery: [
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=600&auto=format&fit=crop&q=80'
    ],
    description: 'Advanced health sensors, bright Always-On Retina display, crash detection, and powerful fitness metrics. Water resistant to 50 meters with precision dual-frequency GPS.'
  },
  {
    id: 3,
    name: 'Logitech MX Master 3S Wireless Performance Mouse',
    category: 'Accessories',
    price: 84,
    originalPrice: 99,
    discount: 15,
    stock: 40,
    sellerId: 1,
    seller: 'Demo Seller',
    rating: 4.9,
    reviews: 215,
    image: 'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=600&auto=format&fit=crop&q=80',
    gallery: [
      'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=600&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=600&auto=format&fit=crop&q=80'
    ],
    description: 'Quiet clicks, 8K DPI track-on-glass sensor, ultra-fast MagSpeed scrolling for creators and developers. Ergonomic silhouette crafted for palm support.'
  },
  {
    id: 4,
    name: 'Dell UltraSharp 27 4K UHD USB-C Hub Monitor',
    category: 'Monitors',
    price: 551,
    originalPrice: 599,
    discount: 8,
    stock: 3, // Low stock demo
    sellerId: 1,
    seller: 'Demo Seller',
    rating: 4.7,
    reviews: 64,
    image: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=600&auto=format&fit=crop&q=80',
    gallery: [
      'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=600&auto=format&fit=crop&q=80'
    ],
    description: 'Brilliant 4K clarity, IPS Black technology with 2000:1 contrast ratio, comprehensive USB-C hub connectivity providing up to 90W power delivery.'
  },
  {
    id: 5,
    name: 'Keychron K2 Pro QMK Wireless Mechanical Keyboard',
    category: 'Accessories',
    price: 104,
    originalPrice: 119,
    discount: 12,
    stock: 0, // Out of stock demo
    sellerId: 2,
    seller: 'Apex Electronics',
    rating: 4.8,
    reviews: 83,
    image: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&auto=format&fit=crop&q=80',
    gallery: [
      'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&auto=format&fit=crop&q=80'
    ],
    description: 'Custom mechanical keyboard with RGB backlighting, hot-swappable switches, sound-absorbing foam, and multi-device Bluetooth.'
  },
  {
    id: 6,
    name: 'Kindle Paperwhite 16GB 6.8" Glare-Free Display',
    category: 'E-Readers',
    price: 149,
    originalPrice: 149,
    discount: 0,
    stock: 22,
    sellerId: 1,
    seller: 'Demo Seller',
    rating: 4.9,
    reviews: 178,
    image: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&auto=format&fit=crop&q=80',
    gallery: [
      'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=600&auto=format&fit=crop&q=80'
    ],
    description: 'Now with a 6.8" display, thinner borders, adjustable warm light, up to 10 weeks of battery life, and 20% faster page turns.'
  }
];

export default function App() {
  const [currentPage, setCurrentPage] = useState<'home' | 'products' | 'detail' | 'signin' | 'signup' | 'signup_success' | 'unauthorized' | 'cart' | 'checkout' | 'order_confirmation'>('products');
  const [selectedProduct, setSelectedProduct] = useState<ProductItem>(INITIAL_PRODUCTS[0]);
  const [detailSelectedImage, setDetailSelectedImage] = useState<string>(INITIAL_PRODUCTS[0].image);
  const [detailQuantity, setDetailQuantity] = useState<number>(1);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [selectedSort, setSelectedSort] = useState('newest');
  const [filterMineOnly, setFilterMineOnly] = useState(false);
  const [cartItems, setCartItems] = useState<CartItemData[]>([
    { id: 1, product: INITIAL_PRODUCTS[0], quantity: 1 },
    { id: 2, product: INITIAL_PRODUCTS[2], quantity: 2 },
  ]);
  const [userDropdownOpen, setUserDropdownOpen] = useState(false);
  const [activeSession, setActiveSession] = useState<'guest' | 'buyer' | 'seller'>('buyer');
  const [uploadModalProduct, setUploadModalProduct] = useState<ProductItem | null>(null);
  const [toastMessage, setToastMessage] = useState<string | null>(null);

  // Phase 7 Checkout & Order State
  const [checkoutFullName, setCheckoutFullName] = useState('Demo Buyer');
  const [checkoutPhone, setCheckoutPhone] = useState('9123456780');
  const [checkoutAddress, setCheckoutAddress] = useState('452 Market Street, Suite 300');
  const [checkoutCity, setCheckoutCity] = useState('San Francisco');
  const [checkoutState, setCheckoutState] = useState('California');
  const [checkoutPostalCode, setCheckoutPostalCode] = useState('94105');
  const [checkoutPaymentMethod, setCheckoutPaymentMethod] = useState('COD');
  const [checkoutError, setCheckoutError] = useState<string | null>(null);
  const [placedOrder, setPlacedOrder] = useState<OrderData | null>(null);

  const cartCount = (activeSession === 'buyer' || activeSession === 'guest')
    ? cartItems.reduce((acc, item) => acc + item.quantity, 0)
    : 0;

  // Sign In Form State
  const [signInEmail, setSignInEmail] = useState('');
  const [signInPassword, setSignInPassword] = useState('');
  const [showSignInPassword, setShowSignInPassword] = useState(false);
  const [signInError, setSignInError] = useState<string | null>(null);

  // Sign Up Form State
  const [signUpRole, setSignUpRole] = useState<'B' | 'S'>('B');
  const [signUpName, setSignUpName] = useState('');
  const [signUpEmail, setSignUpEmail] = useState('');
  const [signUpPhone, setSignUpPhone] = useState('');
  const [signUpPassword, setSignUpPassword] = useState('');
  const [signUpConfirm, setSignUpConfirm] = useState('');
  const [showSignUpPassword, setShowSignUpPassword] = useState(false);
  const [showSignUpConfirm, setShowSignUpConfirm] = useState(false);
  const [signUpAgree, setSignUpAgree] = useState(true);
  const [signUpError, setSignUpError] = useState<string | null>(null);
  const [emailCheckStatus, setEmailCheckStatus] = useState<'idle' | 'checking' | 'available' | 'taken' | 'invalid'>('idle');

  const showToast = (msg: string) => {
    setToastMessage(msg);
    setTimeout(() => setToastMessage(null), 3500);
  };

  const handleOpenDetail = (product: ProductItem) => {
    setSelectedProduct(product);
    setDetailSelectedImage(product.image);
    setDetailQuantity(1);
    setCurrentPage('detail');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleAddToCart = (product: ProductItem, qty: number = 1, redirectToCart: boolean = false) => {
    if (activeSession === 'seller') {
      showToast("Seller accounts cannot purchase or add items to cart!");
      return;
    }
    if (activeSession === 'guest') {
      showToast("Please sign in as a Buyer to add items to cart (signin.jsp).");
      setCurrentPage('signin');
      return;
    }

    setCartItems(prev => {
      const existing = prev.find(item => item.product.id === product.id);
      if (existing) {
        let newQty = existing.quantity + qty;
        if (newQty > product.stock) {
          newQty = product.stock;
          showToast(`Quantity capped to available stock (${product.stock}) for "${product.name.substring(0, 16)}..."`);
        } else {
          showToast(`Updated "${product.name.substring(0, 18)}..." in your cart! (add_to_cart.do)`);
        }
        return prev.map(item => item.product.id === product.id ? { ...item, quantity: newQty } : item);
      } else {
        const initialQty = Math.min(qty, product.stock);
        showToast(`Added "${product.name.substring(0, 18)}..." to your cart! (add_to_cart.do)`);
        return [...prev, { id: Date.now(), product, quantity: initialQty }];
      }
    });

    if (redirectToCart) {
      setCurrentPage('cart');
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  };

  const updateCartQuantity = (itemId: number, newQty: number) => {
    setCartItems(prev => prev.map(item => {
      if (item.id === itemId) {
        const clamped = Math.max(1, Math.min(newQty, item.product.stock));
        return { ...item, quantity: clamped };
      }
      return item;
    }));
    showToast("Cart updated successfully (update_cart.do)!");
  };

  const removeFromCart = (itemId: number) => {
    setCartItems(prev => prev.filter(item => item.id !== itemId));
    showToast("Item removed from your cart (remove_from_cart.do).");
  };

  const handleProceedToCheckout = () => {
    if (activeSession === 'guest') {
      showToast("Please sign in as a Buyer to proceed to checkout (signin.jsp).");
      setCurrentPage('signin');
      return;
    }
    if (activeSession === 'seller') {
      showToast("Seller accounts cannot make purchases.");
      return;
    }
    if (cartItems.length === 0) {
      showToast("Your cart is empty. Please add products first.");
      return;
    }
    const hasOutStock = cartItems.some(i => i.product.stock <= 0 || i.quantity > i.product.stock);
    if (hasOutStock) {
      showToast("Some items exceed available stock. Please adjust quantities.");
      return;
    }
    setCheckoutError(null);
    setCurrentPage('checkout');
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handlePlaceOrder = (e: React.FormEvent) => {
    e.preventDefault();
    if (!checkoutFullName.trim()) {
      setCheckoutError("Recipient Full Name is required.");
      return;
    }
    if (!checkoutPhone.trim() || checkoutPhone.trim().replace(/\D/g, '').length < 7) {
      setCheckoutError("Valid contact phone number is required (at least 7 digits).");
      return;
    }
    if (!checkoutAddress.trim()) {
      setCheckoutError("Delivery Street Address is required.");
      return;
    }
    if (!checkoutCity.trim()) {
      setCheckoutError("City is required.");
      return;
    }
    if (!checkoutState.trim()) {
      setCheckoutError("State / Province is required.");
      return;
    }
    if (!checkoutPostalCode.trim()) {
      setCheckoutError("Postal / ZIP Code is required.");
      return;
    }

    if (cartItems.length === 0) {
      setCheckoutError("Cart is empty. Cannot place an empty order.");
      return;
    }

    // Atomic simulation: verify stock
    for (const item of cartItems) {
      if (item.quantity > item.product.stock) {
        setCheckoutError(`Insufficient stock for "${item.product.name}". Only ${item.product.stock} available.`);
        return;
      }
    }

    // Recalculate totals
    const subtotal = cartItems.reduce((acc, it) => acc + (it.product.price * it.quantity), 0);
    const shipping = subtotal >= 50 ? 0 : 10;
    const tax = Math.round(subtotal * 0.08);
    const grandTotal = subtotal + shipping + tax;

    const orderId = Math.floor(100000 + Math.random() * 900000);
    const orderItemsSnapshot: OrderItemData[] = cartItems.map(it => ({
      productId: it.product.id,
      productName: it.product.name,
      price: it.product.price,
      quantity: it.quantity,
      subtotal: it.product.price * it.quantity,
      image: it.product.image
    }));

    const newOrder: OrderData = {
      orderId,
      customerName: checkoutFullName.trim(),
      phone: checkoutPhone.trim(),
      address: checkoutAddress.trim(),
      city: checkoutCity.trim(),
      state: checkoutState.trim(),
      postalCode: checkoutPostalCode.trim(),
      subtotal,
      shipping,
      tax,
      grandTotal,
      orderStatus: 'CONFIRMED',
      paymentStatus: checkoutPaymentMethod === 'COD' ? 'COD' : 'PENDING',
      orderDate: new Date().toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric', hour: '2-digit', minute: '2-digit' }),
      items: orderItemsSnapshot
    };

    // Deduct stock in memory
    for (const item of cartItems) {
      item.product.stock = Math.max(0, item.product.stock - item.quantity);
    }

    // Clear cart
    setCartItems([]);
    setPlacedOrder(newOrder);
    setCheckoutError(null);
    setCurrentPage('order_confirmation');
    window.scrollTo({ top: 0, behavior: 'smooth' });
    showToast(`Order #CN-${orderId} placed successfully! Transaction committed.`);
  };

  // Password strength calculation
  const getPasswordStrength = (pass: string) => {
    if (!pass) return { score: 0, label: 'Enter password', color: 'text-slate-400' };
    if (pass.length < 6) return { score: 1, label: 'Too Short (min 6 chars)', color: 'text-rose-500' };
    let score = 1;
    if (pass.length >= 8) score++;
    if (/[0-9]/.test(pass)) score++;
    if (/[A-Z]/.test(pass) || /[^A-Za-z0-9]/.test(pass)) score++;

    if (score === 2) return { score: 2, label: 'Fair', color: 'text-amber-500' };
    if (score === 3) return { score: 3, label: 'Good', color: 'text-blue-500' };
    return { score: 4, label: 'Strong', color: 'text-emerald-500' };
  };

  const pwStrength = getPasswordStrength(signUpPassword);

  // Email verification simulation
  const handleSignUpEmailChange = (val: string) => {
    setSignUpEmail(val);
    if (!val.trim()) {
      setEmailCheckStatus('idle');
      return;
    }
    const isValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val.trim());
    if (!isValid) {
      setEmailCheckStatus('invalid');
      return;
    }
    setEmailCheckStatus('checking');
    setTimeout(() => {
      const lower = val.trim().toLowerCase();
      if (lower === 'existing@example.com' || lower === 'seller@cartnova.com' || lower === 'buyer@cartnova.com') {
        setEmailCheckStatus('taken');
      } else {
        setEmailCheckStatus('available');
      }
    }, 400);
  };

  // Handle Sign In submission
  const handleSignInSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!signInEmail.trim() || !signInPassword.trim()) {
      setSignInError('Both email and password are required.');
      return;
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(signInEmail.trim())) {
      setSignInError('Please enter a valid email format (e.g. name@domain.com).');
      return;
    }
    setSignInError(null);
    const isSeller = signInEmail.toLowerCase().includes('seller');
    setActiveSession(isSeller ? 'seller' : 'buyer');
    showToast(`Signed in successfully as ${isSeller ? 'Demo Seller' : 'Demo Buyer'} (signin.do)!`);
    setCurrentPage('products');
  };

  // Handle Sign Up submission
  const handleSignUpSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!signUpName.trim() || signUpName.trim().length < 2) {
      setSignUpError('Please enter your full name (minimum 2 characters).');
      return;
    }
    if (!signUpEmail.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(signUpEmail.trim())) {
      setSignUpError('Please enter a valid email address.');
      return;
    }
    if (emailCheckStatus === 'taken') {
      setSignUpError('An account with this email already exists. Please sign in instead.');
      return;
    }
    const cleanPhone = signUpPhone.replace(/[^0-9]/g, '');
    if (!cleanPhone || cleanPhone.length < 10) {
      setSignUpError('Please provide a valid 10-digit mobile number.');
      return;
    }
    if (signUpPassword.length < 6) {
      setSignUpError('Password must be at least 6 characters long.');
      return;
    }
    if (signUpPassword !== signUpConfirm) {
      setSignUpError('Passwords do not match.');
      return;
    }
    if (!signUpAgree) {
      setSignUpError('You must agree to the Terms of Service.');
      return;
    }

    setSignUpError(null);
    showToast('Registration successful! Redirecting to confirmation page (signup.do)...');
    setCurrentPage('signup_success');
  };

  const categories = ['All', 'Audio', 'Wearables', 'Accessories', 'Monitors', 'E-Readers'];

  const filteredProducts = INITIAL_PRODUCTS.filter(item => {
    const matchesCategory = selectedCategory === 'All' || item.category.toLowerCase() === selectedCategory.toLowerCase();
    const matchesSearch = item.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          item.description.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesMine = !filterMineOnly || (activeSession === 'seller' && item.sellerId === 1);
    return matchesCategory && matchesSearch && matchesMine;
  }).sort((a, b) => {
    if (selectedSort === 'price_asc') return a.price - b.price;
    if (selectedSort === 'price_desc') return b.price - a.price;
    if (selectedSort === 'discount') return b.discount - a.discount;
    if (selectedSort === 'stock') return b.stock - a.stock;
    if (selectedSort === 'name_asc') return a.name.localeCompare(b.name);
    return b.id - a.id;
  });

  return (
    <div className="min-h-screen bg-slate-50 text-slate-800 flex flex-col font-sans">
      
      {/* Toast Notification */}
      {toastMessage && (
        <div className="fixed bottom-6 right-6 z-50 bg-slate-900 text-white px-5 py-3 rounded-xl shadow-2xl flex items-center gap-3 border border-slate-700 animate-in fade-in slide-in-from-bottom-3">
          <CheckCircle2 className="w-5 h-5 text-emerald-400" />
          <span className="text-sm font-semibold">{toastMessage}</span>
        </div>
      )}

      {/* Upload Product Photos Modal Simulation */}
      {uploadModalProduct && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-xs p-4">
          <div className="bg-white rounded-2xl max-w-md w-full p-6 shadow-2xl border border-slate-100 animate-in zoom-in-95">
            <div className="flex justify-between items-center pb-3 border-b border-slate-100">
              <h3 className="font-bold text-slate-900 flex items-center gap-2 text-base">
                <Camera className="w-5 h-5 text-blue-600" /> Upload Product Photos
              </h3>
              <button onClick={() => setUploadModalProduct(null)} className="text-slate-400 hover:text-slate-600">
                <X className="w-5 h-5" />
              </button>
            </div>
            
            <div className="py-4 space-y-3">
              <div className="bg-slate-50 p-3 rounded-xl border border-slate-200">
                <p className="text-xs font-semibold text-slate-500">Selected Product (ID: {uploadModalProduct.id})</p>
                <p className="text-sm font-bold text-slate-900 line-clamp-1">{uploadModalProduct.name}</p>
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1.5">
                  Select Product Images (Multiple allowed)
                </label>
                <input 
                  type="file" 
                  multiple 
                  accept="image/*"
                  className="w-full text-xs text-slate-500 file:mr-3 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100 border border-slate-200 rounded-xl p-2 cursor-pointer"
                />
                <p className="text-[11px] text-slate-400 mt-1">
                  Posted to servlet: <code className="text-blue-600">product_pic.do</code>
                </p>
              </div>
            </div>

            <div className="flex justify-end gap-2 pt-3 border-t border-slate-100">
              <button 
                onClick={() => setUploadModalProduct(null)}
                className="px-4 py-2 rounded-full text-xs font-semibold text-slate-600 hover:bg-slate-100">
                Cancel
              </button>
              <button 
                onClick={() => {
                  setUploadModalProduct(null);
                  showToast(`Photos uploaded for "${uploadModalProduct.name.substring(0, 20)}..." (product_pic.do)!`);
                }}
                className="px-4 py-2 rounded-full text-xs font-bold bg-blue-600 text-white hover:bg-blue-700 shadow-sm">
                Upload Photos
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Top Demo Bar (Phase 5 Navigator) */}
      <div className="bg-slate-950 text-slate-300 text-xs py-2 px-4 border-b border-slate-800">
        <div className="max-w-7xl mx-auto flex flex-wrap justify-between items-center gap-2">
          
          <div className="flex items-center gap-3">
            <span className="flex items-center gap-1.5 text-blue-400 font-bold">
              <Sparkles className="w-3.5 h-3.5 text-amber-400" />
              <span>Phase 6 Active: Real Shopping Cart (cart.do & cart.jsp)</span>
            </span>

            {/* View Switcher */}
            <div className="inline-flex rounded-lg bg-slate-900 p-0.5 border border-slate-800 flex-wrap">
              <button 
                onClick={() => { setCurrentPage('home'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                className={`px-2.5 py-1 text-xs rounded-md transition font-medium ${currentPage === 'home' ? 'bg-indigo-600 text-white font-bold' : 'text-slate-400 hover:text-white'}`}>
                index.jsp
              </button>
              <button 
                onClick={() => { setCurrentPage('products'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                className={`px-2.5 py-1 text-xs rounded-md transition font-medium ${currentPage === 'products' ? 'bg-blue-600 text-white font-bold' : 'text-slate-400 hover:text-white'}`}>
                products.jsp
              </button>
              <button 
                onClick={() => { setCurrentPage('detail'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                className={`px-2.5 py-1 text-xs rounded-md transition font-medium ${currentPage === 'detail' ? 'bg-emerald-600 text-white font-bold' : 'text-slate-400 hover:text-white'}`}>
                product_detail.jsp
              </button>
              <button 
                onClick={() => { setCurrentPage('cart'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                className={`px-2.5 py-1 text-xs rounded-md transition font-medium ${currentPage === 'cart' ? 'bg-blue-600 text-white font-bold' : 'text-slate-400 hover:text-white'}`}>
                cart.jsp ({cartCount})
              </button>
              <button 
                onClick={() => { setCurrentPage('signin'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                className={`px-2.5 py-1 text-xs rounded-md transition font-medium ${currentPage === 'signin' ? 'bg-amber-600 text-white font-bold' : 'text-slate-400 hover:text-white'}`}>
                signin.jsp
              </button>
              <button 
                onClick={() => { setCurrentPage('signup'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                className={`px-2.5 py-1 text-xs rounded-md transition font-medium ${currentPage === 'signup' ? 'bg-purple-600 text-white font-bold' : 'text-slate-400 hover:text-white'}`}>
                signup.jsp
              </button>
              <button 
                onClick={() => { setCurrentPage('signup_success'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                className={`px-2.5 py-1 text-xs rounded-md transition font-medium ${currentPage === 'signup_success' ? 'bg-teal-600 text-white font-bold' : 'text-slate-400 hover:text-white'}`}>
                signup_success.jsp
              </button>
              <button 
                onClick={() => { setCurrentPage('unauthorized'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                className={`px-2.5 py-1 text-xs rounded-md transition font-medium ${currentPage === 'unauthorized' ? 'bg-rose-600 text-white font-bold' : 'text-slate-400 hover:text-white'}`}>
                unauthorized.jsp
              </button>
            </div>
          </div>

          {/* Session Switcher */}
          <div className="flex items-center gap-3">
            <span className="text-slate-400 hidden md:inline">Session User:</span>
            <div className="inline-flex rounded-lg bg-slate-900 p-0.5 border border-slate-800">
              <button 
                onClick={() => { setActiveSession('guest'); setUserDropdownOpen(false); setFilterMineOnly(false); }}
                className={`px-2.5 py-1 text-xs rounded-md transition font-medium ${activeSession === 'guest' ? 'bg-blue-600 text-white' : 'text-slate-400 hover:text-white'}`}>
                Guest
              </button>
              <button 
                onClick={() => { setActiveSession('buyer'); setUserDropdownOpen(false); setFilterMineOnly(false); }}
                className={`px-2.5 py-1 text-xs rounded-md transition font-medium ${activeSession === 'buyer' ? 'bg-blue-600 text-white' : 'text-slate-400 hover:text-white'}`}>
                Buyer
              </button>
              <button 
                onClick={() => { setActiveSession('seller'); setUserDropdownOpen(false); }}
                className={`px-2.5 py-1 text-xs rounded-md transition font-medium ${activeSession === 'seller' ? 'bg-amber-600 text-white' : 'text-slate-400 hover:text-white'}`}>
                Seller
              </button>
            </div>
          </div>

        </div>
      </div>

      {/* Main Sticky Header (navbar.jsp) */}
      <header className="sticky top-0 z-40 bg-white/95 backdrop-blur-md border-b border-slate-200/80 shadow-xs">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-20 gap-4">
            
            {/* Brand Logo */}
            <button onClick={() => { setCurrentPage('home'); window.scrollTo({ top: 0, behavior: 'smooth' }); }} className="flex items-center gap-2.5 group text-left">
              <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-blue-600 to-indigo-600 flex items-center justify-center text-white shadow-md shadow-blue-500/25 group-hover:scale-105 transition">
                <ShoppingBag className="w-5 h-5" />
              </div>
              <div className="flex flex-col">
                <span className="text-2xl font-black tracking-tight text-slate-900 leading-none">
                  Cart<span className="text-blue-600">Nova</span>
                </span>
                <span className="text-[10px] uppercase font-bold tracking-widest text-slate-500">JSP &bull; JDBC &bull; MySQL</span>
              </div>
            </button>

            {/* Global Search Bar (products.do?search=...) */}
            <div className="hidden md:flex flex-1 max-w-md relative mx-4">
              <input
                type="text"
                value={searchTerm}
                onChange={(e) => {
                  setSearchTerm(e.target.value);
                  if (currentPage !== 'products') setCurrentPage('products');
                }}
                placeholder="Search products by name or description..."
                className="w-full bg-slate-100/90 text-slate-900 placeholder:text-slate-500 pl-4 pr-11 py-2.5 rounded-full border border-slate-200 text-sm focus:outline-none focus:border-blue-500 focus:bg-white focus:ring-3 focus:ring-blue-100 transition"
              />
              <button 
                onClick={() => { setCurrentPage('products'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                className="absolute right-1.5 top-1/2 -translate-y-1/2 w-8 h-8 rounded-full bg-blue-600 text-white flex items-center justify-center hover:bg-blue-700 transition"
                aria-label="Submit search">
                <Search className="w-4 h-4" />
              </button>
            </div>

            {/* Navigation Actions */}
            <div className="flex items-center gap-3">
              <button 
                onClick={() => { setCurrentPage('products'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                className={`hidden lg:inline-flex text-sm font-semibold px-3 py-1.5 rounded-lg transition ${currentPage === 'products' ? 'text-blue-600 bg-blue-50' : 'text-slate-600 hover:text-blue-600'}`}>
                All Products (products.do)
              </button>

              {activeSession === 'guest' ? (
                <div className="hidden sm:flex items-center gap-2">
                  <button 
                    onClick={() => { setCurrentPage('signin'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                    className="inline-flex items-center gap-1.5 text-sm font-semibold text-slate-700 hover:text-blue-600 px-3 py-2 rounded-lg hover:bg-slate-100 transition">
                    <UserIcon className="w-4 h-4" /> Sign In
                  </button>
                  <button 
                    onClick={() => { setCurrentPage('signup'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                    className="inline-flex items-center justify-center px-4 py-2 rounded-full text-xs font-bold bg-blue-600 text-white hover:bg-blue-700 shadow-sm transition">
                    Join Free
                  </button>
                </div>
              ) : (
                <div className="relative">
                  <button 
                    onClick={() => setUserDropdownOpen(!userDropdownOpen)}
                    className="flex items-center gap-2.5 p-1.5 rounded-full hover:bg-slate-100 transition border border-slate-200">
                    <div className="w-8 h-8 rounded-full bg-gradient-to-tr from-blue-600 to-indigo-600 flex items-center justify-center text-white text-xs font-bold">
                      {activeSession === 'seller' ? 'S' : 'B'}
                    </div>
                    <div className="hidden xl:flex flex-col text-left">
                      <span className="text-xs font-bold text-slate-900 leading-tight">
                        {activeSession === 'seller' ? 'Demo Seller' : 'Demo Buyer'}
                      </span>
                      <span className="text-[10px] text-slate-500 font-medium">
                        {activeSession === 'seller' ? 'Seller Central' : 'Buyer Profile'}
                      </span>
                    </div>
                    <ChevronDown className="w-3.5 h-3.5 text-slate-400 mr-1" />
                  </button>

                  {userDropdownOpen && (
                    <div className="absolute right-0 mt-2 w-56 bg-white rounded-2xl shadow-xl border border-slate-100 py-2 z-50 animate-in fade-in slide-in-from-top-2">
                      <div className="px-4 py-2.5 border-b border-slate-100">
                        <p className="text-xs font-bold text-slate-900">
                          {activeSession === 'seller' ? 'Demo Seller' : 'Demo Buyer'}
                        </p>
                        <p className="text-[11px] text-slate-500 truncate">
                          {activeSession === 'seller' ? 'seller@cartnova.com' : 'buyer@cartnova.com'}
                        </p>
                        <span className={`inline-block mt-1 px-2 py-0.5 rounded text-[10px] font-bold ${activeSession === 'seller' ? 'bg-amber-100 text-amber-800' : 'bg-blue-100 text-blue-800'}`}>
                          {activeSession === 'seller' ? 'Verified Seller' : 'Registered Buyer'}
                        </span>
                      </div>
                      
                      <button onClick={() => { setUserDropdownOpen(false); showToast("Opens dashboard.jsp"); }} className="w-full flex items-center gap-2.5 px-4 py-2 text-xs font-semibold text-slate-700 hover:bg-slate-50 hover:text-blue-600 text-left">
                        <LayoutDashboard className="w-4 h-4 text-blue-600" /> Dashboard.jsp
                      </button>
                      <button onClick={() => { setUserDropdownOpen(false); showToast("Opens user_profile.do"); }} className="w-full flex items-center gap-2.5 px-4 py-2 text-xs font-semibold text-slate-700 hover:bg-slate-50 hover:text-blue-600 text-left">
                        <UserIcon className="w-4 h-4 text-blue-600" /> My Profile (user_profile.do)
                      </button>

                      {activeSession === 'seller' ? (
                        <>
                          <button onClick={() => { setCurrentPage('products'); setFilterMineOnly(true); setUserDropdownOpen(false); }} className="w-full flex items-center gap-2.5 px-4 py-2 text-xs font-semibold text-slate-700 hover:bg-slate-50 hover:text-blue-600 text-left">
                            <Tag className="w-4 h-4 text-amber-600" /> My Listed Products
                          </button>
                          <button onClick={() => { setUserDropdownOpen(false); showToast("Opens add_product.do"); }} className="w-full flex items-center gap-2.5 px-4 py-2 text-xs font-semibold text-slate-700 hover:bg-slate-50 hover:text-blue-600 text-left">
                            <PlusCircle className="w-4 h-4 text-amber-600" /> Add New Product.jsp
                          </button>
                        </>
                      ) : (
                        <>
                          <button onClick={() => { setUserDropdownOpen(false); setCurrentPage('cart'); window.scrollTo({ top: 0, behavior: 'smooth' }); }} className="w-full flex items-center gap-2.5 px-4 py-2 text-xs font-semibold text-slate-700 hover:bg-slate-50 hover:text-blue-600 text-left">
                            <ShoppingBag className="w-4 h-4 text-blue-600" /> My Cart ({cartCount})
                          </button>
                          <button onClick={() => { setUserDropdownOpen(false); showToast("Opens my_orders.do"); }} className="w-full flex items-center gap-2.5 px-4 py-2 text-xs font-semibold text-slate-700 hover:bg-slate-50 hover:text-blue-600 text-left">
                            <Receipt className="w-4 h-4 text-blue-600" /> My Orders
                          </button>
                        </>
                      )}

                      <div className="border-t border-slate-100 my-1"></div>
                      <button 
                        onClick={() => {
                          setActiveSession('guest');
                          setUserDropdownOpen(false);
                          setCurrentPage('signin');
                          showToast("Signed out successfully (signout.do)!");
                        }} 
                        className="w-full flex items-center gap-2.5 px-4 py-2 text-xs font-semibold text-rose-600 hover:bg-rose-50 text-left">
                        <LogOut className="w-4 h-4" /> Sign Out (signout.do)
                      </button>
                    </div>
                  )}
                </div>
              )}

              {/* Cart UI Button */}
              {activeSession !== 'seller' && (
                <button 
                  onClick={() => { setCurrentPage('cart'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                  className="relative p-2.5 rounded-full hover:bg-slate-100 text-slate-700 transition"
                  aria-label="View Cart">
                  <ShoppingBag className="w-5 h-5" />
                  {cartCount > 0 && (
                    <span className="absolute top-1 right-1 w-4 h-4 rounded-full bg-blue-600 text-white text-[10px] font-bold flex items-center justify-center animate-in zoom-in">
                      {cartCount}
                    </span>
                  )}
                </button>
              )}

            </div>
          </div>
        </div>
      </header>

      {/* Main Page Content */}
      <main className="flex-1">

        {/* ============================================================== */}
        {/* VIEW 1: SIGN IN PAGE (signin.jsp)                              */}
        {/* ============================================================== */}
        {currentPage === 'signin' ? (
          <div className="py-12 px-4 sm:px-6 flex items-center justify-center min-h-[calc(100vh-280px)]">
            <div className="bg-white border border-slate-200 rounded-3xl p-8 sm:p-10 shadow-xl max-w-md w-full animate-in fade-in zoom-in-95">
              
              <div className="text-center mb-6">
                <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-blue-600 to-indigo-600 text-white flex items-center justify-center mx-auto mb-4 shadow-lg shadow-blue-500/25">
                  <LogIn className="w-6 h-6" />
                </div>
                <h1 className="text-2xl font-black text-slate-900 tracking-tight">Welcome Back</h1>
                <p className="text-xs text-slate-500 mt-1">
                  Sign in to your CartNova buyer or seller account
                </p>
              </div>

              {/* Error Alert Display */}
              {signInError && (
                <div className="mb-5 p-3.5 rounded-xl bg-rose-50 border border-rose-200 text-rose-700 text-xs font-semibold flex items-center gap-2.5">
                  <AlertTriangle className="w-4 h-4 text-rose-500 shrink-0" />
                  <span>{signInError}</span>
                </div>
              )}

              <form onSubmit={handleSignInSubmit} className="space-y-4">
                <div>
                  <label className="block text-[11px] font-bold uppercase tracking-wider text-slate-700 mb-1.5">
                    Email Address <span className="text-rose-500">*</span>
                  </label>
                  <div className="relative">
                    <Mail className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                    <input 
                      type="email" 
                      value={signInEmail}
                      onChange={(e) => setSignInEmail(e.target.value)}
                      placeholder="you@example.com"
                      className="w-full bg-white pl-10 pr-4 py-2.5 rounded-xl border border-slate-300 text-xs text-slate-900 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition"
                      required
                    />
                  </div>
                </div>

                <div>
                  <div className="flex justify-between items-center mb-1.5">
                    <label className="text-[11px] font-bold uppercase tracking-wider text-slate-700">
                      Password <span className="text-rose-500">*</span>
                    </label>
                    <button type="button" onClick={() => showToast("Password reset link will be sent to your email.")} className="text-[11px] text-blue-600 hover:underline font-semibold">
                      Forgot?
                    </button>
                  </div>
                  <div className="relative">
                    <Lock className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                    <input 
                      type={showSignInPassword ? 'text' : 'password'}
                      value={signInPassword}
                      onChange={(e) => setSignInPassword(e.target.value)}
                      placeholder="Enter your password"
                      className="w-full bg-white pl-10 pr-10 py-2.5 rounded-xl border border-slate-300 text-xs text-slate-900 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition"
                      required
                    />
                    <button 
                      type="button" 
                      onClick={() => setShowSignInPassword(!showSignInPassword)}
                      className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600">
                      {showSignInPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                    </button>
                  </div>
                </div>

                <div className="flex items-center justify-between text-xs pt-1">
                  <label className="flex items-center gap-2 cursor-pointer select-none text-slate-600">
                    <input type="checkbox" defaultChecked className="rounded border-slate-300 text-blue-600 focus:ring-blue-500" />
                    <span>Remember my login</span>
                  </label>
                  <span className="text-[11px] text-slate-400 flex items-center gap-1">
                    <ShieldCheck className="w-3.5 h-3.5 text-emerald-500" /> 256-bit Secure
                  </span>
                </div>

                <button 
                  type="submit"
                  className="w-full py-3 px-6 rounded-xl bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs flex items-center justify-center gap-2 shadow-md shadow-blue-500/25 transition">
                  <LogIn className="w-4 h-4" />
                  <span>Sign In to Account (signin.do)</span>
                </button>
              </form>

              {/* Demo Accounts Quick-Fill Hint */}
              <div className="mt-6 pt-5 border-t border-slate-100 text-center">
                <p className="text-xs text-slate-500 mb-3">
                  Don't have an account yet?{' '}
                  <button onClick={() => setCurrentPage('signup')} className="text-blue-600 font-bold hover:underline">
                    Create Free Account
                  </button>
                </p>

                <div className="bg-slate-50 p-3 rounded-xl border border-slate-200 text-left">
                  <p className="text-[11px] font-bold text-slate-700 mb-1 flex items-center gap-1.5">
                    <HelpCircle className="w-3.5 h-3.5 text-blue-600" /> Quick Demo Fill
                  </p>
                  <div className="flex gap-2 mt-2">
                    <button 
                      onClick={() => { setSignInEmail('buyer@cartnova.com'); setSignInPassword('password123'); }}
                      className="flex-1 py-1.5 px-2 bg-white border border-slate-200 hover:border-blue-400 rounded-lg text-[10px] font-bold text-slate-700 text-center transition">
                      Fill Buyer (buyer@...)
                    </button>
                    <button 
                      onClick={() => { setSignInEmail('seller@cartnova.com'); setSignInPassword('password123'); }}
                      className="flex-1 py-1.5 px-2 bg-white border border-slate-200 hover:border-amber-400 rounded-lg text-[10px] font-bold text-slate-700 text-center transition">
                      Fill Seller (seller@...)
                    </button>
                  </div>
                </div>
              </div>

            </div>
          </div>
        ) : currentPage === 'signup' ? (
          /* ============================================================== */
          /* VIEW 2: SIGN UP PAGE (signup.jsp)                              */
          /* ============================================================== */
          <div className="py-12 px-4 sm:px-6 flex items-center justify-center min-h-[calc(100vh-280px)]">
            <div className="bg-white border border-slate-200 rounded-3xl p-8 sm:p-10 shadow-xl max-w-lg w-full animate-in fade-in zoom-in-95">
              
              <div className="text-center mb-6">
                <div className="w-14 h-14 rounded-2xl bg-gradient-to-tr from-indigo-600 to-purple-600 text-white flex items-center justify-center mx-auto mb-4 shadow-lg shadow-indigo-500/25">
                  <UserCheck className="w-6 h-6" />
                </div>
                <h1 className="text-2xl font-black text-slate-900 tracking-tight">Create Your Account</h1>
                <p className="text-xs text-slate-500 mt-1">
                  Join CartNova to buy authentic electronics or register as a merchant
                </p>
              </div>

              {/* Error Alert Display */}
              {signUpError && (
                <div className="mb-5 p-3.5 rounded-xl bg-rose-50 border border-rose-200 text-rose-700 text-xs font-semibold flex items-center gap-2.5">
                  <AlertTriangle className="w-4 h-4 text-rose-500 shrink-0" />
                  <span>{signUpError}</span>
                </div>
              )}

              <form onSubmit={handleSignUpSubmit} className="space-y-4">
                
                {/* Account Type Selector Cards */}
                <div>
                  <label className="block text-[11px] font-bold uppercase tracking-wider text-slate-700 mb-2">
                    Select Account Type
                  </label>
                  <div className="grid grid-cols-2 gap-3">
                    <button
                      type="button"
                      onClick={() => setSignUpRole('B')}
                      className={`p-3.5 rounded-2xl border text-center transition flex flex-col items-center gap-1.5 ${
                        signUpRole === 'B' 
                          ? 'border-blue-600 bg-blue-50/70 ring-2 ring-blue-500/20' 
                          : 'border-slate-200 bg-white hover:bg-slate-50'
                      }`}>
                      <div className={`w-8 h-8 rounded-xl flex items-center justify-center ${signUpRole === 'B' ? 'bg-blue-600 text-white' : 'bg-slate-100 text-slate-600'}`}>
                        <ShoppingBag className="w-4 h-4" />
                      </div>
                      <span className="text-xs font-bold text-slate-900">Buyer (Customer)</span>
                      <span className="text-[10px] text-slate-500 line-clamp-1">Shop electronics</span>
                    </button>

                    <button
                      type="button"
                      onClick={() => setSignUpRole('S')}
                      className={`p-3.5 rounded-2xl border text-center transition flex flex-col items-center gap-1.5 ${
                        signUpRole === 'S' 
                          ? 'border-amber-600 bg-amber-50/70 ring-2 ring-amber-500/20' 
                          : 'border-slate-200 bg-white hover:bg-slate-50'
                      }`}>
                      <div className={`w-8 h-8 rounded-xl flex items-center justify-center ${signUpRole === 'S' ? 'bg-amber-600 text-white' : 'bg-slate-100 text-slate-600'}`}>
                        <Tag className="w-4 h-4" />
                      </div>
                      <span className="text-xs font-bold text-slate-900">Seller (Merchant)</span>
                      <span className="text-[10px] text-slate-500 line-clamp-1">List & sell items</span>
                    </button>
                  </div>
                </div>

                {/* Full Name */}
                <div>
                  <label className="block text-[11px] font-bold uppercase tracking-wider text-slate-700 mb-1.5">
                    Full Name <span className="text-rose-500">*</span>
                  </label>
                  <div className="relative">
                    <UserIcon className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                    <input 
                      type="text" 
                      value={signUpName}
                      onChange={(e) => setSignUpName(e.target.value)}
                      placeholder="e.g. Alex Morgan"
                      className="w-full bg-white pl-10 pr-4 py-2.5 rounded-xl border border-slate-300 text-xs text-slate-900 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition"
                      required
                    />
                  </div>
                </div>

                {/* Email Address with Real-time Verification */}
                <div>
                  <label className="block text-[11px] font-bold uppercase tracking-wider text-slate-700 mb-1.5">
                    Email Address <span className="text-rose-500">*</span>
                  </label>
                  <div className="relative">
                    <Mail className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                    <input 
                      type="email" 
                      value={signUpEmail}
                      onChange={(e) => handleSignUpEmailChange(e.target.value)}
                      placeholder="alex@example.com"
                      className={`w-full bg-white pl-10 pr-4 py-2.5 rounded-xl border text-xs text-slate-900 focus:outline-none transition ${
                        emailCheckStatus === 'available' ? 'border-emerald-500 ring-2 ring-emerald-100' :
                        emailCheckStatus === 'taken' || emailCheckStatus === 'invalid' ? 'border-rose-500 ring-2 ring-rose-100' :
                        'border-slate-300 focus:border-blue-500 focus:ring-2 focus:ring-blue-100'
                      }`}
                      required
                    />
                  </div>

                  {/* Real-time Email Availability Indicator */}
                  {emailCheckStatus === 'checking' && (
                    <div className="mt-1.5 text-[11px] text-sky-600 flex items-center gap-1.5 animate-pulse">
                      <div className="w-3 h-3 border-2 border-sky-600 border-t-transparent rounded-full animate-spin"></div>
                      <span>Checking email availability via check_email_exists.do...</span>
                    </div>
                  )}
                  {emailCheckStatus === 'available' && (
                    <div className="mt-1.5 text-[11px] text-emerald-600 font-semibold flex items-center gap-1.5">
                      <CheckCircle className="w-3.5 h-3.5 text-emerald-500" />
                      <span>Great news! This email is available for registration.</span>
                    </div>
                  )}
                  {emailCheckStatus === 'taken' && (
                    <div className="mt-1.5 text-[11px] text-rose-600 font-semibold flex items-center gap-1.5">
                      <AlertTriangle className="w-3.5 h-3.5 text-rose-500" />
                      <span>Account with this email already exists. Try signing in.</span>
                    </div>
                  )}
                  {emailCheckStatus === 'invalid' && (
                    <div className="mt-1.5 text-[11px] text-amber-600 flex items-center gap-1.5">
                      <AlertTriangle className="w-3.5 h-3.5 text-amber-500" />
                      <span>Please enter a valid email format (e.g. name@domain.com).</span>
                    </div>
                  )}
                </div>

                {/* Phone Number */}
                <div>
                  <label className="block text-[11px] font-bold uppercase tracking-wider text-slate-700 mb-1.5">
                    Phone Number <span className="text-rose-500">*</span>
                  </label>
                  <div className="relative">
                    <Phone className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                    <input 
                      type="tel" 
                      value={signUpPhone}
                      onChange={(e) => setSignUpPhone(e.target.value)}
                      placeholder="10-digit mobile number"
                      className="w-full bg-white pl-10 pr-4 py-2.5 rounded-xl border border-slate-300 text-xs text-slate-900 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition"
                      required
                    />
                  </div>
                </div>

                {/* Password with Strength Meter */}
                <div>
                  <label className="block text-[11px] font-bold uppercase tracking-wider text-slate-700 mb-1.5">
                    Password <span className="text-rose-500">*</span>
                  </label>
                  <div className="relative">
                    <Lock className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                    <input 
                      type={showSignUpPassword ? 'text' : 'password'}
                      value={signUpPassword}
                      onChange={(e) => setSignUpPassword(e.target.value)}
                      placeholder="Minimum 6 characters"
                      className="w-full bg-white pl-10 pr-10 py-2.5 rounded-xl border border-slate-300 text-xs text-slate-900 focus:outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-100 transition"
                      required
                    />
                    <button 
                      type="button" 
                      onClick={() => setShowSignUpPassword(!showSignUpPassword)}
                      className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600">
                      {showSignUpPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                    </button>
                  </div>

                  {/* Real-Time Password Strength Meter */}
                  <div className="mt-2 space-y-1">
                    <div className="flex gap-1.5 h-1">
                      <div className={`flex-1 rounded-full transition ${pwStrength.score >= 1 ? (pwStrength.score === 1 ? 'bg-rose-500' : pwStrength.score === 2 ? 'bg-amber-500' : 'bg-emerald-500') : 'bg-slate-200'}`}></div>
                      <div className={`flex-1 rounded-full transition ${pwStrength.score >= 2 ? (pwStrength.score === 2 ? 'bg-amber-500' : 'bg-emerald-500') : 'bg-slate-200'}`}></div>
                      <div className={`flex-1 rounded-full transition ${pwStrength.score >= 3 ? 'bg-emerald-500' : 'bg-slate-200'}`}></div>
                      <div className={`flex-1 rounded-full transition ${pwStrength.score >= 4 ? 'bg-emerald-500' : 'bg-slate-200'}`}></div>
                    </div>
                    <div className="flex justify-between items-center text-[10px]">
                      <span className={`font-bold ${pwStrength.color}`}>{pwStrength.label}</span>
                      <span className="text-slate-400">Min 6 characters</span>
                    </div>
                  </div>
                </div>

                {/* Confirm Password with Live Matching */}
                <div>
                  <label className="block text-[11px] font-bold uppercase tracking-wider text-slate-700 mb-1.5">
                    Confirm Password <span className="text-rose-500">*</span>
                  </label>
                  <div className="relative">
                    <KeyRound className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                    <input 
                      type={showSignUpConfirm ? 'text' : 'password'}
                      value={signUpConfirm}
                      onChange={(e) => setSignUpConfirm(e.target.value)}
                      placeholder="Re-enter password"
                      className={`w-full bg-white pl-10 pr-10 py-2.5 rounded-xl border text-xs text-slate-900 focus:outline-none transition ${
                        signUpConfirm.length > 0 && signUpConfirm === signUpPassword 
                          ? 'border-emerald-500 ring-2 ring-emerald-100' 
                          : signUpConfirm.length > 0 && signUpConfirm !== signUpPassword
                          ? 'border-rose-500 ring-2 ring-rose-100'
                          : 'border-slate-300 focus:border-blue-500'
                      }`}
                      required
                    />
                    <button 
                      type="button" 
                      onClick={() => setShowSignUpConfirm(!showSignUpConfirm)}
                      className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600">
                      {showSignUpConfirm ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                    </button>
                  </div>

                  {/* Password Match Feedback */}
                  {signUpConfirm.length > 0 && (
                    <div className="mt-1.5 text-[11px] font-semibold flex items-center gap-1.5">
                      {signUpConfirm === signUpPassword ? (
                        <span className="text-emerald-600 flex items-center gap-1">
                          <CheckCircle className="w-3.5 h-3.5 text-emerald-500" /> Passwords match perfectly.
                        </span>
                      ) : (
                        <span className="text-rose-600 flex items-center gap-1">
                          <AlertTriangle className="w-3.5 h-3.5 text-rose-500" /> Passwords do not match.
                        </span>
                      )}
                    </div>
                  )}
                </div>

                {/* Terms Checkbox */}
                <div className="pt-1">
                  <label className="flex items-center gap-2 cursor-pointer select-none text-xs text-slate-600">
                    <input 
                      type="checkbox" 
                      checked={signUpAgree}
                      onChange={(e) => setSignUpAgree(e.target.checked)}
                      className="rounded border-slate-300 text-blue-600 focus:ring-blue-500" 
                    />
                    <span>
                      I agree to the <button type="button" onClick={() => showToast("Terms of Service")} className="text-blue-600 font-semibold hover:underline">Terms</button> and <button type="button" onClick={() => showToast("Privacy Policy")} className="text-blue-600 font-semibold hover:underline">Privacy Policy</button>
                    </span>
                  </label>
                </div>

                {/* Submit Action */}
                <button 
                  type="submit"
                  className="w-full py-3 px-6 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-bold text-xs flex items-center justify-center gap-2 shadow-md shadow-blue-500/25 transition">
                  <UserCheck className="w-4 h-4" />
                  <span>Register Account (signup.do)</span>
                </button>
              </form>

              <div className="mt-6 pt-5 border-t border-slate-100 text-center">
                <p className="text-xs text-slate-500">
                  Already have an account?{' '}
                  <button onClick={() => setCurrentPage('signin')} className="text-blue-600 font-bold hover:underline">
                    Sign In Here
                  </button>
                </p>
              </div>

            </div>
          </div>
        ) : currentPage === 'signup_success' ? (
          /* ============================================================== */
          /* VIEW 3: SIGNUP SUCCESS ONBOARDING (signup_success.jsp)          */
          /* ============================================================== */
          <div className="py-12 px-4 sm:px-6 flex items-center justify-center min-h-[calc(100vh-280px)]">
            <div className="bg-white border border-slate-200 rounded-3xl p-8 sm:p-12 shadow-xl max-w-lg w-full text-center animate-in zoom-in-95">
              
              <div className="w-20 h-20 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto mb-6 shadow-xl shadow-emerald-500/20">
                <Check className="w-10 h-10 stroke-[3]" />
              </div>

              <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">Account Created!</h1>
              <p className="text-xs sm:text-sm text-slate-500 mt-2 max-w-sm mx-auto">
                Welcome to <strong>CartNova E-Commerce</strong>. Your user account has been successfully recorded in the MySQL database.
              </p>

              <div className="grid grid-cols-3 gap-3 my-8 text-center">
                <div className="bg-slate-50 p-3 rounded-2xl border border-slate-100">
                  <ShieldCheck className="w-5 h-5 text-blue-600 mx-auto mb-1.5" />
                  <p className="text-[11px] font-bold text-slate-800">Verified User</p>
                  <p className="text-[9px] text-slate-500">Encrypted session</p>
                </div>
                <div className="bg-slate-50 p-3 rounded-2xl border border-slate-100">
                  <Truck className="w-5 h-5 text-blue-600 mx-auto mb-1.5" />
                  <p className="text-[11px] font-bold text-slate-800">Fast Shipping</p>
                  <p className="text-[9px] text-slate-500">Express delivery</p>
                </div>
                <div className="bg-slate-50 p-3 rounded-2xl border border-slate-100">
                  <Headset className="w-5 h-5 text-blue-600 mx-auto mb-1.5" />
                  <p className="text-[11px] font-bold text-slate-800">24/7 Support</p>
                  <p className="text-[9px] text-slate-500">Live assistance</p>
                </div>
              </div>

              <div className="space-y-2.5">
                <button 
                  onClick={() => { setCurrentPage('signin'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                  className="w-full py-3 px-6 rounded-full bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs flex items-center justify-center gap-2 shadow-md shadow-blue-500/25 transition">
                  <LogIn className="w-4 h-4" /> Sign In to Your Account (signin.do)
                </button>
                <button 
                  onClick={() => { setCurrentPage('products'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                  className="w-full py-3 px-6 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs flex items-center justify-center gap-2 transition">
                  <Search className="w-4 h-4" /> Explore Products Catalog (products.do)
                </button>
                <button 
                  onClick={() => { setCurrentPage('home'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                  className="text-xs text-slate-500 hover:text-slate-800 pt-2 font-medium">
                  Return to Homepage (index.jsp)
                </button>
              </div>

            </div>
          </div>
        ) : currentPage === 'unauthorized' ? (
          /* ============================================================== */
          /* VIEW 4: UNAUTHORIZED ACCESS (unauthorized_access.jsp)          */
          /* ============================================================== */
          <div className="py-12 px-4 sm:px-6 flex items-center justify-center min-h-[calc(100vh-280px)]">
            <div className="bg-white border border-slate-200 rounded-3xl p-8 sm:p-12 shadow-xl max-w-md w-full text-center animate-in zoom-in-95">
              
              <div className="w-20 h-20 rounded-full bg-rose-100 text-rose-600 flex items-center justify-center mx-auto mb-6 shadow-xl shadow-rose-500/20">
                <ShieldAlert className="w-10 h-10 stroke-[2.5]" />
              </div>

              <h1 className="text-2xl font-black text-slate-900 tracking-tight">Access Denied</h1>
              <p className="text-xs sm:text-sm text-slate-500 mt-2 leading-relaxed">
                You do not have permission to view this resource or your session has expired. Certain pages (like adding products or uploading inventory) require verified Seller privileges.
              </p>

              <div className="space-y-2.5 mt-8">
                <button 
                  onClick={() => { setCurrentPage('signin'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                  className="w-full py-3 px-6 rounded-full bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs flex items-center justify-center gap-2 shadow-md shadow-blue-500/25 transition">
                  <LogIn className="w-4 h-4" /> Sign In with Authorized Account
                </button>
                <button 
                  onClick={() => { setCurrentPage('home'); window.scrollTo({ top: 0, behavior: 'smooth' }); }}
                  className="w-full py-3 px-6 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs flex items-center justify-center gap-2 transition">
                  Return to Homepage (index.jsp)
                </button>
              </div>

            </div>
          </div>
        ) : currentPage === 'cart' ? (
          /* ============================================================== */
          /* VIEW 5: SHOPPING CART (cart.do & cart.jsp)                     */
          /* ============================================================== */
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-in fade-in duration-300">
            {/* Breadcrumb Bar */}
            <div className="flex items-center gap-2 text-xs text-slate-500 mb-6 flex-wrap">
              <button onClick={() => setCurrentPage('home')} className="hover:text-blue-600 flex items-center gap-1">
                index.jsp (Home)
              </button>
              <span className="text-slate-300">/</span>
              <button onClick={() => setCurrentPage('products')} className="hover:text-blue-600">
                products.jsp (Catalog)
              </button>
              <span className="text-slate-300">/</span>
              <span className="text-slate-900 font-bold">cart.jsp (Shopping Cart)</span>
            </div>

            {/* Header */}
            <div className="flex flex-col sm:flex-row sm:items-end justify-between gap-4 pb-4 border-b border-slate-200 mb-6">
              <div>
                <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">Shopping Cart</h1>
                <p className="text-xs sm:text-sm text-slate-500 mt-1">
                  {cartItems.length > 0 
                    ? `You have ${cartCount} item${cartCount === 1 ? '' : 's'} in your database-backed cart.` 
                    : 'Your cart is currently empty. Explore our verified marketplace catalog below.'}
                </p>
              </div>
              {cartItems.length > 0 && (
                <button 
                  onClick={() => setCurrentPage('products')}
                  className="inline-flex items-center gap-1.5 text-xs font-bold text-blue-600 hover:text-blue-700 bg-blue-50 hover:bg-blue-100 px-3.5 py-2 rounded-full transition w-fit">
                  <Plus className="w-3.5 h-3.5" /> Continue Shopping
                </button>
              )}
            </div>

            {activeSession === 'seller' ? (
              <div className="p-8 text-center bg-white rounded-3xl border border-slate-200 max-w-lg mx-auto shadow-sm">
                <ShieldAlert className="w-12 h-12 text-amber-500 mx-auto mb-3" />
                <h2 className="text-lg font-bold text-slate-900">Seller Account Active</h2>
                <p className="text-xs text-slate-500 mt-2 mb-6">
                  Shopping carts are only available for Buyer accounts. Switch your session to <strong>Buyer</strong> using the top simulator bar.
                </p>
                <button 
                  onClick={() => setActiveSession('buyer')}
                  className="px-6 py-2.5 rounded-full bg-blue-600 text-white font-bold text-xs shadow-md">
                  Switch to Demo Buyer Session
                </button>
              </div>
            ) : cartItems.length === 0 ? (
              /* Empty Cart State */
              <div className="bg-white border border-slate-200 rounded-3xl p-12 text-center max-w-lg mx-auto shadow-sm">
                <div className="w-20 h-20 rounded-full bg-blue-50 text-blue-600 flex items-center justify-center mx-auto mb-5 shadow-inner">
                  <ShoppingBag className="w-10 h-10" />
                </div>
                <h2 className="text-xl font-black text-slate-900 tracking-tight">Your Cart is Empty</h2>
                <p className="text-xs text-slate-500 mt-2 mb-6 leading-relaxed">
                  Looks like you haven't added any products to your shopping cart yet. Browse our verified electronics catalog and find top-tier gear.
                </p>
                <div className="flex flex-col sm:flex-row justify-center gap-3">
                  <button 
                    onClick={() => setCurrentPage('products')}
                    className="px-6 py-3 rounded-full bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs shadow-md shadow-blue-500/20 transition">
                    Explore Products (products.do)
                  </button>
                  <button 
                    onClick={() => setCurrentPage('home')}
                    className="px-6 py-3 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs transition">
                    Return Home
                  </button>
                </div>
              </div>
            ) : (
              /* Active Cart Grid */
              <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                {/* Left Column: Cart Items (8 cols) */}
                <div className="lg:col-span-8 space-y-4">
                  {cartItems.some(i => i.product.stock <= 0 || i.quantity > i.product.stock) && (
                    <div className="p-4 rounded-2xl bg-amber-50 border border-amber-200 text-amber-800 text-xs font-semibold flex items-center gap-3">
                      <AlertTriangle className="w-5 h-5 text-amber-500 shrink-0" />
                      <span>Some items have limited available stock in inventory. Please adjust quantities before checkout.</span>
                    </div>
                  )}

                  <div className="bg-white rounded-3xl border border-slate-200 divide-y divide-slate-100 shadow-sm overflow-hidden">
                    {cartItems.map((item) => {
                      const outOfStock = item.product.stock <= 0;
                      const lowStock = item.product.stock > 0 && item.product.stock <= 5;
                      const subtotal = item.product.price * item.quantity;

                      return (
                        <div key={item.id} className="p-5 sm:p-6 flex flex-col sm:flex-row items-start sm:items-center gap-4 sm:gap-6 hover:bg-slate-50/50 transition">
                          {/* Thumbnail */}
                          <div 
                            onClick={() => handleOpenDetail(item.product)}
                            className="w-20 h-20 sm:w-24 sm:h-24 rounded-2xl bg-slate-100 border border-slate-200 flex items-center justify-center p-2 shrink-0 cursor-pointer overflow-hidden group">
                            <img 
                              src={item.product.image} 
                              alt={item.product.name}
                              className="max-h-full max-w-full object-contain group-hover:scale-105 transition" 
                            />
                          </div>

                          {/* Details */}
                          <div className="flex-1 min-w-0">
                            <button 
                              onClick={() => handleOpenDetail(item.product)}
                              className="text-sm font-bold text-slate-900 hover:text-blue-600 transition text-left line-clamp-1 block">
                              {item.product.name}
                            </button>
                            
                            <div className="flex items-center gap-2 mt-1 flex-wrap">
                              <span className="text-xs font-bold text-slate-800">${item.product.price} each</span>
                              {item.product.discount > 0 && (
                                <>
                                  <span className="text-[11px] text-slate-400 line-through">${item.product.originalPrice}</span>
                                  <span className="text-[10px] font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-full border border-emerald-200">
                                    {item.product.discount}% OFF
                                  </span>
                                </>
                              )}
                            </div>

                            {/* Stock Status Pill */}
                            <div className="mt-2">
                              {outOfStock ? (
                                <span className="inline-flex items-center gap-1 text-[11px] font-bold text-rose-700 bg-rose-50 px-2.5 py-0.5 rounded-full border border-rose-200">
                                  <X className="w-3 h-3" /> Out of Stock
                                </span>
                              ) : lowStock ? (
                                <span className="inline-flex items-center gap-1 text-[11px] font-bold text-amber-700 bg-amber-50 px-2.5 py-0.5 rounded-full border border-amber-200">
                                  <AlertTriangle className="w-3 h-3" /> Only {item.product.stock} left
                                </span>
                              ) : (
                                <span className="inline-flex items-center gap-1 text-[11px] font-bold text-emerald-700 bg-emerald-50 px-2.5 py-0.5 rounded-full border border-emerald-200">
                                  <Check className="w-3 h-3" /> In Stock ({item.product.stock} available)
                                </span>
                              )}
                            </div>
                          </div>

                          {/* Quantity & Actions */}
                          <div className="w-full sm:w-auto flex items-center justify-between sm:justify-end gap-5 pt-3 sm:pt-0 border-t sm:border-0 border-slate-100">
                            {/* Quantity Picker */}
                            <div className="inline-flex items-center border border-slate-300 rounded-xl bg-white shadow-xs overflow-hidden">
                              <button 
                                onClick={() => updateCartQuantity(item.id, item.quantity - 1)}
                                disabled={item.quantity <= 1 || outOfStock}
                                className="w-8 h-8 flex items-center justify-center text-slate-600 hover:bg-slate-100 disabled:opacity-40 disabled:cursor-not-allowed">
                                <Minus className="w-3.5 h-3.5" />
                              </button>
                              <span className="w-10 text-center text-xs font-bold text-slate-900">
                                {item.quantity}
                              </span>
                              <button 
                                onClick={() => updateCartQuantity(item.id, item.quantity + 1)}
                                disabled={item.quantity >= item.product.stock || outOfStock}
                                className="w-8 h-8 flex items-center justify-center text-slate-600 hover:bg-slate-100 disabled:opacity-40 disabled:cursor-not-allowed">
                                <Plus className="w-3.5 h-3.5" />
                              </button>
                            </div>

                            {/* Subtotal */}
                            <div className="text-right sm:min-w-[80px]">
                              <div className="text-sm font-black text-slate-900">${subtotal}</div>
                              <span className="text-[10px] text-slate-400">Subtotal</span>
                            </div>

                            {/* Delete button */}
                            <button 
                              onClick={() => removeFromCart(item.id)}
                              className="p-2 rounded-xl text-slate-400 hover:text-rose-600 hover:bg-rose-50 transition"
                              title="Remove item (remove_from_cart.do)">
                              <Trash2 className="w-4 h-4" />
                            </button>
                          </div>
                        </div>
                      );
                    })}
                  </div>

                  <div className="flex justify-between items-center pt-2">
                    <button 
                      onClick={() => setCurrentPage('products')}
                      className="text-xs font-bold text-slate-600 hover:text-slate-900 flex items-center gap-1.5">
                      <ArrowLeft className="w-3.5 h-3.5" /> Continue Shopping
                    </button>
                    <span className="text-xs text-slate-400 flex items-center gap-1">
                      <Lock className="w-3.5 h-3.5 text-emerald-600" /> 256-bit SSL Protected
                    </span>
                  </div>
                </div>

                {/* Right Column: Order Summary (4 cols) */}
                <div className="lg:col-span-4">
                  {(() => {
                    const subtotal = cartItems.reduce((acc, it) => acc + (it.product.price * it.quantity), 0);
                    const shipping = subtotal >= 50 || cartItems.length === 0 ? 0 : 10;
                    const tax = Math.round(subtotal * 0.08);
                    const grandTotal = subtotal + shipping + tax;

                    return (
                      <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-7 shadow-sm sticky top-24">
                        <h2 className="text-base font-black text-slate-900 pb-3 border-b border-slate-100">Order Summary</h2>

                        <div className="space-y-3 py-4 text-xs text-slate-600">
                          <div className="flex justify-between items-center">
                            <span>Subtotal ({cartCount} items)</span>
                            <span className="font-bold text-slate-900">${subtotal}</span>
                          </div>
                          <div className="flex justify-between items-center">
                            <span>Estimated Shipping</span>
                            {shipping === 0 ? (
                              <span className="font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-full text-[10px]">
                                FREE
                              </span>
                            ) : (
                              <span className="font-bold text-slate-900">${shipping}</span>
                            )}
                          </div>
                          {shipping > 0 && (
                            <div className="p-2.5 rounded-xl bg-slate-50 text-[11px] text-slate-500">
                              Add <strong className="text-blue-600">${50 - subtotal}</strong> more to qualify for <strong>FREE Shipping</strong>!
                            </div>
                          )}
                          <div className="flex justify-between items-center">
                            <span>Estimated Tax (8%)</span>
                            <span className="font-bold text-slate-900">${tax}</span>
                          </div>
                          <div className="pt-3 border-t border-dashed border-slate-200 flex justify-between items-center text-sm font-black text-slate-900">
                            <span>Total</span>
                            <span className="text-blue-600 text-lg">${grandTotal}</span>
                          </div>
                        </div>

                        <div className="space-y-2.5 pt-2">
                          <button 
                            onClick={handleProceedToCheckout}
                            className="w-full py-3.5 px-6 rounded-full bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs flex items-center justify-center gap-2 shadow-lg shadow-blue-500/25 transition">
                            <Lock className="w-3.5 h-3.5" /> Proceed to Checkout
                          </button>
                          <div className="text-center">
                            <span className="text-[10px] font-semibold text-emerald-700 bg-emerald-50 px-2.5 py-1 rounded-full border border-emerald-200 inline-block">
                              <ShieldCheck className="w-3 h-3 inline mr-1 text-emerald-600" />
                              Secure Checkout (checkout.do)
                            </span>
                          </div>
                          <button 
                            onClick={() => setCurrentPage('products')}
                            className="w-full py-2.5 px-6 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs transition">
                            Browse More Products
                          </button>
                        </div>

                        <div className="border-t border-slate-100 mt-6 pt-4 space-y-2 text-[11px] text-slate-500">
                          <div className="flex items-center gap-2">
                            <ShieldCheck className="w-4 h-4 text-emerald-600 shrink-0" />
                            <span>256-Bit SSL Bank-Grade Security</span>
                          </div>
                          <div className="flex items-center gap-2">
                            <RotateCcw className="w-4 h-4 text-emerald-600 shrink-0" />
                            <span>30-Day Money-Back Guarantee</span>
                          </div>
                          <div className="flex items-center gap-2">
                            <Truck className="w-4 h-4 text-emerald-600 shrink-0" />
                            <span>Fast Dispatch with Order Tracking</span>
                          </div>
                        </div>
                      </div>
                    );
                  })()}
                </div>
              </div>
            )}
          </div>
        ) : currentPage === 'checkout' ? (
          /* ============================================================== */
          /* VIEW: CHECKOUT (checkout.jsp / checkout.do)                    */
          /* ============================================================== */
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-in fade-in duration-300">
            {/* Breadcrumb Bar */}
            <div className="flex items-center gap-2 text-xs text-slate-500 mb-6 flex-wrap">
              <button onClick={() => setCurrentPage('home')} className="hover:text-blue-600">Home</button>
              <span>/</span>
              <button onClick={() => setCurrentPage('cart')} className="hover:text-blue-600">Cart</button>
              <span>/</span>
              <span className="font-semibold text-slate-900">Checkout</span>
            </div>

            {/* Stepper Progress */}
            <div className="flex items-center justify-center gap-4 sm:gap-6 mb-8 text-xs font-semibold">
              <div className="flex items-center gap-2 text-emerald-600">
                <span className="w-6 h-6 rounded-full bg-emerald-100 text-emerald-700 flex items-center justify-center font-bold text-[11px]">
                  <Check className="w-3.5 h-3.5" />
                </span>
                <span>1. Cart ({cartCount})</span>
              </div>
              <div className="w-8 sm:w-12 h-0.5 bg-slate-200"></div>
              <div className="flex items-center gap-2 text-blue-600">
                <span className="w-6 h-6 rounded-full bg-blue-600 text-white flex items-center justify-center font-bold text-[11px] ring-4 ring-blue-100">
                  2
                </span>
                <span>2. Shipping & Checkout</span>
              </div>
              <div className="w-8 sm:w-12 h-0.5 bg-slate-200"></div>
              <div className="flex items-center gap-2 text-slate-400">
                <span className="w-6 h-6 rounded-full bg-slate-100 text-slate-500 flex items-center justify-center font-bold text-[11px]">
                  3
                </span>
                <span>3. Confirmation</span>
              </div>
            </div>

            {/* Error Banner */}
            {checkoutError && (
              <div className="mb-6 p-4 rounded-2xl bg-rose-50 border border-rose-200 text-rose-700 text-xs flex items-center gap-3">
                <AlertTriangle className="w-5 h-5 text-rose-600 shrink-0" />
                <span><strong>Order Validation Warning:</strong> {checkoutError}</span>
              </div>
            )}

            <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
              {/* Left Column: Checkout Form (8 cols) */}
              <div className="lg:col-span-8">
                <form onSubmit={handlePlaceOrder} className="space-y-6">
                  {/* Customer Information Card */}
                  <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-7 shadow-xs">
                    <div className="flex items-center gap-3 pb-4 mb-4 border-b border-slate-100">
                      <div className="w-9 h-9 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center">
                        <UserIcon className="w-5 h-5" />
                      </div>
                      <div>
                        <h2 className="text-sm font-bold text-slate-900">Customer Account</h2>
                        <p className="text-[11px] text-slate-500">Authenticated user details</p>
                      </div>
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 text-xs">
                      <div>
                        <label className="block text-slate-600 font-semibold mb-1">Account Name</label>
                        <input type="text" readOnly value="Demo Buyer" className="w-full px-3.5 py-2.5 rounded-xl bg-slate-50 border border-slate-200 text-slate-700 font-medium cursor-not-allowed" />
                      </div>
                      <div>
                        <label className="block text-slate-600 font-semibold mb-1">Email Address</label>
                        <input type="email" readOnly value="buyer@shopsphere.com" className="w-full px-3.5 py-2.5 rounded-xl bg-slate-50 border border-slate-200 text-slate-700 font-medium cursor-not-allowed" />
                      </div>
                    </div>
                  </div>

                  {/* Shipping Address Card */}
                  <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-7 shadow-xs">
                    <div className="flex items-center gap-3 pb-4 mb-4 border-b border-slate-100">
                      <div className="w-9 h-9 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center">
                        <Truck className="w-5 h-5" />
                      </div>
                      <div>
                        <h2 className="text-sm font-bold text-slate-900">Shipping Address</h2>
                        <p className="text-[11px] text-slate-500">Where should we deliver your order?</p>
                      </div>
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 text-xs">
                      <div>
                        <label className="block text-slate-700 font-semibold mb-1">Recipient Full Name <span className="text-rose-500">*</span></label>
                        <input 
                          type="text" 
                          required 
                          value={checkoutFullName} 
                          onChange={(e) => setCheckoutFullName(e.target.value)} 
                          className="w-full px-3.5 py-2.5 rounded-xl bg-white border border-slate-300 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none transition" 
                        />
                      </div>
                      <div>
                        <label className="block text-slate-700 font-semibold mb-1">Contact Phone Number <span className="text-rose-500">*</span></label>
                        <input 
                          type="tel" 
                          required 
                          value={checkoutPhone} 
                          onChange={(e) => setCheckoutPhone(e.target.value)} 
                          className="w-full px-3.5 py-2.5 rounded-xl bg-white border border-slate-300 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none transition" 
                        />
                      </div>
                      <div className="sm:col-span-2">
                        <label className="block text-slate-700 font-semibold mb-1">Street Address <span className="text-rose-500">*</span></label>
                        <input 
                          type="text" 
                          required 
                          placeholder="Flat/House No., Street Name, Landmark"
                          value={checkoutAddress} 
                          onChange={(e) => setCheckoutAddress(e.target.value)} 
                          className="w-full px-3.5 py-2.5 rounded-xl bg-white border border-slate-300 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none transition" 
                        />
                      </div>
                      <div>
                        <label className="block text-slate-700 font-semibold mb-1">City <span className="text-rose-500">*</span></label>
                        <input 
                          type="text" 
                          required 
                          value={checkoutCity} 
                          onChange={(e) => setCheckoutCity(e.target.value)} 
                          className="w-full px-3.5 py-2.5 rounded-xl bg-white border border-slate-300 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none transition" 
                        />
                      </div>
                      <div className="grid grid-cols-2 gap-2">
                        <div>
                          <label className="block text-slate-700 font-semibold mb-1">State <span className="text-rose-500">*</span></label>
                          <input 
                            type="text" 
                            required 
                            value={checkoutState} 
                            onChange={(e) => setCheckoutState(e.target.value)} 
                            className="w-full px-3.5 py-2.5 rounded-xl bg-white border border-slate-300 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none transition" 
                          />
                        </div>
                        <div>
                          <label className="block text-slate-700 font-semibold mb-1">Postal / ZIP <span className="text-rose-500">*</span></label>
                          <input 
                            type="text" 
                            required 
                            value={checkoutPostalCode} 
                            onChange={(e) => setCheckoutPostalCode(e.target.value)} 
                            className="w-full px-3.5 py-2.5 rounded-xl bg-white border border-slate-300 focus:border-blue-600 focus:ring-2 focus:ring-blue-100 outline-none transition" 
                          />
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Payment Method Card (COD default) */}
                  <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-7 shadow-xs">
                    <div className="flex items-center gap-3 pb-4 mb-4 border-b border-slate-100">
                      <div className="w-9 h-9 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center">
                        <Receipt className="w-5 h-5" />
                      </div>
                      <div>
                        <h2 className="text-sm font-bold text-slate-900">Payment Option</h2>
                        <p className="text-[11px] text-slate-500">Phase 7 supported payment method</p>
                      </div>
                    </div>

                    <div className="p-4 rounded-2xl border-2 border-blue-600 bg-blue-50/50 flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        <input 
                          type="radio" 
                          id="codRadio" 
                          name="paymentRadio" 
                          checked={checkoutPaymentMethod === 'COD'} 
                          onChange={() => setCheckoutPaymentMethod('COD')}
                          className="w-4 h-4 text-blue-600"
                        />
                        <label htmlFor="codRadio" className="text-xs font-bold text-slate-900 cursor-pointer">
                          Cash on Delivery (COD) / Pay upon Arrival
                        </label>
                      </div>
                      <span className="text-[10px] font-bold text-emerald-700 bg-emerald-100 px-2 py-0.5 rounded-full">
                        Zero Fee
                      </span>
                    </div>
                    <p className="text-[11px] text-slate-500 mt-2">
                      Pay easily via Cash or UPI when your parcel is delivered at your doorstep.
                    </p>
                  </div>

                  {/* Place Order CTA Button */}
                  <button 
                    type="submit"
                    className="w-full py-4 px-6 rounded-full bg-blue-600 hover:bg-blue-700 text-white font-bold text-sm flex items-center justify-center gap-2 shadow-lg shadow-blue-500/25 transition">
                    <Lock className="w-4 h-4" /> Confirm & Place Order (place_order.do)
                  </button>
                </form>
              </div>

              {/* Right Column: Checkout Summary (4 cols) */}
              <div className="lg:col-span-4">
                {(() => {
                  const subtotal = cartItems.reduce((acc, it) => acc + (it.product.price * it.quantity), 0);
                  const shipping = subtotal >= 50 || cartItems.length === 0 ? 0 : 10;
                  const tax = Math.round(subtotal * 0.08);
                  const grandTotal = subtotal + shipping + tax;

                  return (
                    <div className="bg-white rounded-3xl border border-slate-200 p-6 sm:p-7 shadow-xs sticky top-24">
                      <h2 className="text-base font-black text-slate-900 pb-3 border-b border-slate-100">Order Summary</h2>

                      {/* Items Preview */}
                      <div className="py-4 space-y-3 max-h-56 overflow-y-auto border-b border-slate-100">
                        {cartItems.map(item => (
                          <div key={item.id} className="flex items-center gap-3">
                            <img src={item.product.image} alt={item.product.name} className="w-11 h-11 rounded-lg object-cover border border-slate-200 shrink-0" />
                            <div className="min-w-0 flex-1">
                              <p className="text-xs font-semibold text-slate-900 truncate">{item.product.name}</p>
                              <p className="text-[11px] text-slate-500">Qty: {item.quantity} × ${item.product.price}</p>
                            </div>
                            <span className="text-xs font-bold text-slate-900 shrink-0">${item.product.price * item.quantity}</span>
                          </div>
                        ))}
                      </div>

                      {/* Pricing Breakdown */}
                      <div className="space-y-3 py-4 text-xs text-slate-600">
                        <div className="flex justify-between items-center">
                          <span>Subtotal ({cartCount} items)</span>
                          <span className="font-bold text-slate-900">${subtotal}</span>
                        </div>
                        <div className="flex justify-between items-center">
                          <span>Shipping</span>
                          {shipping === 0 ? (
                            <span className="font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded-full text-[10px]">
                              FREE
                            </span>
                          ) : (
                            <span className="font-bold text-slate-900">${shipping}</span>
                          )}
                        </div>
                        <div className="flex justify-between items-center">
                          <span>Estimated Tax (8%)</span>
                          <span className="font-bold text-slate-900">${tax}</span>
                        </div>
                        <div className="pt-3 border-t border-dashed border-slate-200 flex justify-between items-center text-sm font-black text-slate-900">
                          <span>Grand Total</span>
                          <span className="text-blue-600 text-lg">${grandTotal}</span>
                        </div>
                      </div>

                      <button 
                        onClick={() => setCurrentPage('cart')}
                        className="w-full py-2.5 px-4 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs transition flex items-center justify-center gap-1.5 mt-2">
                        <ArrowLeft className="w-3.5 h-3.5" /> Return to Cart
                      </button>

                      <div className="border-t border-slate-100 mt-6 pt-4 space-y-2 text-[11px] text-slate-500">
                        <div className="flex items-center gap-2">
                          <ShieldCheck className="w-4 h-4 text-emerald-600 shrink-0" />
                          <span>256-Bit SSL Bank-Grade Security</span>
                        </div>
                        <div className="flex items-center gap-2">
                          <RotateCcw className="w-4 h-4 text-emerald-600 shrink-0" />
                          <span>30-Day Return Guarantee</span>
                        </div>
                      </div>
                    </div>
                  );
                })()}
              </div>
            </div>
          </div>
        ) : currentPage === 'order_confirmation' && placedOrder ? (
          /* ============================================================== */
          /* VIEW: ORDER CONFIRMATION (order_confirmation.jsp)              */
          /* ============================================================== */
          <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10 animate-in fade-in duration-300">
            <div className="bg-white rounded-3xl border border-slate-200 p-8 sm:p-12 shadow-sm">
              {/* Checkmark Badge */}
              <div className="w-16 h-16 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center mx-auto mb-5 shadow-xs ring-8 ring-emerald-50">
                <Check className="w-8 h-8 stroke-[3]" />
              </div>

              <div className="text-center mb-8">
                <h1 className="text-2xl font-black text-slate-900 mb-2">Thank you for your order!</h1>
                <p className="text-xs text-slate-500 max-w-md mx-auto">
                  Your order has been recorded and safely processed in the CartNova system.
                </p>
                <div className="mt-4 inline-block px-4 py-1.5 rounded-full bg-blue-50 border border-blue-200 text-blue-700 text-xs font-bold">
                  Order ID: #CN-{placedOrder.orderId}
                </div>
              </div>

              {/* Order Meta Box */}
              <div className="bg-slate-50 rounded-2xl border border-slate-200/80 p-5 mb-8 grid grid-cols-2 sm:grid-cols-4 gap-4 text-xs">
                <div>
                  <span className="text-slate-500 block mb-0.5">Date Placed</span>
                  <strong className="text-slate-900">{placedOrder.orderDate}</strong>
                </div>
                <div>
                  <span className="text-slate-500 block mb-0.5">Order Status</span>
                  <span className="font-bold text-emerald-700 bg-emerald-100 px-2 py-0.5 rounded-full text-[10px] inline-block">
                    {placedOrder.orderStatus}
                  </span>
                </div>
                <div>
                  <span className="text-slate-500 block mb-0.5">Payment</span>
                  <strong className="text-slate-900">{placedOrder.paymentStatus}</strong>
                </div>
                <div>
                  <span className="text-slate-500 block mb-0.5">Total Paid/Due</span>
                  <strong className="text-blue-600 text-sm">${placedOrder.grandTotal}</strong>
                </div>
              </div>

              {/* Shipping & Account Details */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-8 text-xs">
                <div className="p-4 rounded-2xl bg-slate-50 border border-slate-200/70">
                  <span className="text-slate-400 font-semibold uppercase text-[10px] tracking-wider block mb-2">
                    <Truck className="w-3.5 h-3.5 inline mr-1 text-blue-600" /> Shipping Destination
                  </span>
                  <p className="font-bold text-slate-900">{placedOrder.customerName}</p>
                  <p className="text-slate-600 mt-0.5">{placedOrder.address}</p>
                  <p className="text-slate-600">{placedOrder.city}, {placedOrder.state} - {placedOrder.postalCode}</p>
                  <p className="text-slate-500 mt-2">Phone: {placedOrder.phone}</p>
                </div>
                <div className="p-4 rounded-2xl bg-slate-50 border border-slate-200/70">
                  <span className="text-slate-400 font-semibold uppercase text-[10px] tracking-wider block mb-2">
                    <UserIcon className="w-3.5 h-3.5 inline mr-1 text-blue-600" /> Customer Account
                  </span>
                  <p className="font-bold text-slate-900">Demo Buyer</p>
                  <p className="text-slate-600 mt-0.5">buyer@shopsphere.com</p>
                  <span className="inline-block mt-3 px-2 py-0.5 rounded-full bg-slate-200 text-slate-700 font-semibold text-[10px]">
                    Buyer Account
                  </span>
                </div>
              </div>

              {/* Purchased Items Table */}
              <h2 className="text-sm font-bold text-slate-900 mb-3">Purchased Items</h2>
              <div className="border border-slate-200 rounded-2xl overflow-hidden mb-6">
                <table className="w-full text-left text-xs">
                  <thead className="bg-slate-50 text-slate-500 font-semibold border-b border-slate-200">
                    <tr>
                      <th className="py-3 px-4">Item</th>
                      <th className="py-3 px-4 text-center">Unit Price</th>
                      <th className="py-3 px-4 text-center">Qty</th>
                      <th className="py-3 px-4 text-right">Subtotal</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-100">
                    {placedOrder.items.map((it, idx) => (
                      <tr key={idx}>
                        <td className="py-3 px-4">
                          <div className="flex items-center gap-3">
                            <img src={it.image} alt={it.productName} className="w-10 h-10 rounded-lg object-cover border border-slate-200 shrink-0" />
                            <span className="font-semibold text-slate-900 truncate max-w-xs">{it.productName}</span>
                          </div>
                        </td>
                        <td className="py-3 px-4 text-center text-slate-700">${it.price}</td>
                        <td className="py-3 px-4 text-center font-bold text-slate-900">{it.quantity}</td>
                        <td className="py-3 px-4 text-right font-bold text-slate-900">${it.subtotal}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* Total Calculation breakdown */}
              <div className="flex justify-end mb-8">
                <div className="w-full sm:w-64 space-y-2 text-xs text-slate-600 bg-slate-50 p-4 rounded-2xl border border-slate-200">
                  <div className="flex justify-between">
                    <span>Subtotal:</span>
                    <strong className="text-slate-900">${placedOrder.subtotal}</strong>
                  </div>
                  <div className="flex justify-between">
                    <span>Shipping:</span>
                    <strong className="text-slate-900">{placedOrder.shipping === 0 ? 'FREE' : `$${placedOrder.shipping}`}</strong>
                  </div>
                  <div className="flex justify-between">
                    <span>Tax (8%):</span>
                    <strong className="text-slate-900">${placedOrder.tax}</strong>
                  </div>
                  <div className="flex justify-between pt-2 border-t border-slate-200 text-sm font-black text-slate-900">
                    <span>Grand Total:</span>
                    <span className="text-blue-600">${placedOrder.grandTotal}</span>
                  </div>
                </div>
              </div>

              {/* Actions */}
              <div className="flex flex-col sm:flex-row justify-center gap-3 pt-4 border-t border-slate-100">
                <button 
                  onClick={() => setCurrentPage('products')}
                  className="py-3 px-6 rounded-full bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs transition flex items-center justify-center gap-2">
                  <ShoppingBag className="w-3.5 h-3.5" /> Continue Shopping
                </button>
                <button 
                  onClick={() => setCurrentPage('home')}
                  className="py-3 px-6 rounded-full bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs transition">
                  Return to Home
                </button>
              </div>
            </div>
          </div>
        ) : currentPage === 'detail' ? (
          /* ============================================================== */
          /* VIEW 5: PRODUCT DETAILS (product_detail.jsp)                   */
          /* ============================================================== */
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-in fade-in duration-300">
            
            {/* Breadcrumb Bar */}
            <div className="flex items-center gap-2 text-xs text-slate-500 mb-6 flex-wrap">
              <button onClick={() => setCurrentPage('home')} className="hover:text-blue-600">Home</button>
              <span>/</span>
              <button onClick={() => setCurrentPage('products')} className="hover:text-blue-600">Products</button>
              <span>/</span>
              <span className="text-slate-400">{selectedProduct.category}</span>
              <span>/</span>
              <span className="font-semibold text-slate-900 truncate max-w-xs">{selectedProduct.name}</span>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-12 gap-10 bg-white border border-slate-200 rounded-3xl p-6 sm:p-10 shadow-xs">
              
              {/* Left Column: Image Gallery */}
              <div className="lg:col-span-6 space-y-4">
                <div className="relative aspect-square rounded-2xl bg-slate-100 border border-slate-200/80 overflow-hidden flex items-center justify-center group">
                  <img 
                    src={detailSelectedImage} 
                    alt={selectedProduct.name}
                    className="w-full h-full object-contain p-6 transition duration-300 group-hover:scale-105"
                  />
                  {selectedProduct.discount > 0 && (
                    <span className="absolute top-4 left-4 bg-rose-600 text-white font-black text-xs px-3 py-1 rounded-full shadow-md">
                      {selectedProduct.discount}% OFF
                    </span>
                  )}
                  {selectedProduct.stock <= 0 && (
                    <div className="absolute inset-0 bg-slate-900/60 backdrop-blur-2xs flex items-center justify-center">
                      <span className="bg-rose-600 text-white font-bold text-xs uppercase px-4 py-1.5 rounded-full tracking-wider shadow-lg">
                        Out of Stock
                      </span>
                    </div>
                  )}
                </div>

                {/* Thumbnail Strip */}
                {selectedProduct.gallery && selectedProduct.gallery.length > 1 && (
                  <div className="flex gap-3 overflow-x-auto pb-2">
                    {selectedProduct.gallery.map((thumb, index) => (
                      <button
                        key={index}
                        onClick={() => setDetailSelectedImage(thumb)}
                        className={`w-20 h-20 rounded-xl bg-slate-50 border-2 overflow-hidden shrink-0 transition p-1.5 ${
                          detailSelectedImage === thumb ? 'border-blue-600 shadow-sm' : 'border-slate-200 hover:border-slate-400'
                        }`}>
                        <img src={thumb} alt={`Thumbnail ${index + 1}`} className="w-full h-full object-contain" />
                      </button>
                    ))}
                  </div>
                )}

                <div className="bg-slate-50 rounded-2xl p-4 border border-slate-200/70 text-xs text-slate-500 space-y-1.5">
                  <div className="flex items-center gap-2 font-bold text-slate-700">
                    <ShieldCheck className="w-4 h-4 text-emerald-600" />
                    <span>CartNova Buyer Guarantee</span>
                  </div>
                  <p>Authentic product inspected by certified seller. 30-day money-back return policy.</p>
                </div>
              </div>

              {/* Right Column: Product Info & Actions */}
              <div className="lg:col-span-6 flex flex-col justify-between space-y-6">
                
                <div className="space-y-4">
                  {/* Category & Rating */}
                  <div className="flex items-center justify-between gap-3">
                    <span className="text-xs font-bold uppercase tracking-wider text-blue-600 bg-blue-50 px-3 py-1 rounded-full">
                      {selectedProduct.category}
                    </span>
                    <div className="flex items-center gap-1.5 text-xs text-amber-500 font-bold">
                      <Star className="w-4 h-4 fill-amber-400 text-amber-400" />
                      <span>{selectedProduct.rating}</span>
                      <span className="text-slate-400 font-normal">({selectedProduct.reviews} reviews)</span>
                    </div>
                  </div>

                  {/* Title */}
                  <h1 className="text-2xl sm:text-3xl font-black text-slate-900 leading-tight">
                    {selectedProduct.name}
                  </h1>

                  {/* Price Section */}
                  <div className="flex items-baseline gap-3 p-4 bg-slate-50 rounded-2xl border border-slate-200/80">
                    <span className="text-3xl sm:text-4xl font-black text-slate-900">
                      ${selectedProduct.price}
                    </span>
                    {selectedProduct.originalPrice > selectedProduct.price && (
                      <span className="text-lg text-slate-400 line-through">
                        ${selectedProduct.originalPrice}
                      </span>
                    )}
                    {selectedProduct.discount > 0 && (
                      <span className="text-xs font-bold text-emerald-600 bg-emerald-50 px-2.5 py-1 rounded-full border border-emerald-200">
                        Save ${selectedProduct.originalPrice - selectedProduct.price}
                      </span>
                    )}
                  </div>

                  {/* Stock Status Badge */}
                  <div className="flex items-center gap-2 pt-1">
                    {selectedProduct.stock > 5 ? (
                      <span className="inline-flex items-center gap-1.5 text-xs font-bold text-emerald-700 bg-emerald-50 border border-emerald-200 px-3 py-1 rounded-full">
                        <Check className="w-3.5 h-3.5 text-emerald-600" /> In Stock ({selectedProduct.stock} available)
                      </span>
                    ) : selectedProduct.stock > 0 ? (
                      <span className="inline-flex items-center gap-1.5 text-xs font-bold text-amber-700 bg-amber-50 border border-amber-200 px-3 py-1 rounded-full">
                        <AlertTriangle className="w-3.5 h-3.5 text-amber-600" /> Only {selectedProduct.stock} left in stock - order soon
                      </span>
                    ) : (
                      <span className="inline-flex items-center gap-1.5 text-xs font-bold text-rose-700 bg-rose-50 border border-rose-200 px-3 py-1 rounded-full">
                        <X className="w-3.5 h-3.5 text-rose-600" /> Currently Out of Stock
                      </span>
                    )}
                  </div>

                  {/* Description */}
                  <div className="pt-2">
                    <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">Description</h3>
                    <p className="text-slate-600 text-xs sm:text-sm leading-relaxed">
                      {selectedProduct.description}
                    </p>
                  </div>

                  {/* Seller Info */}
                  <div className="p-3.5 bg-slate-50 rounded-xl border border-slate-200/80 flex items-center justify-between text-xs">
                    <div>
                      <span className="text-slate-400">Sold by: </span>
                      <span className="font-bold text-slate-900">{selectedProduct.seller}</span>
                    </div>
                    <span className="text-[11px] bg-white border border-slate-200 px-2 py-0.5 rounded-full text-slate-600">
                      Seller ID: #{selectedProduct.sellerId}
                    </span>
                  </div>
                </div>

                {/* Purchase Actions & Quantity Selector */}
                <div className="space-y-4 pt-4 border-t border-slate-100">
                  
                  {/* Quantity Counter */}
                  <div className="flex items-center gap-3">
                    <span className="text-xs font-bold text-slate-700">Quantity:</span>
                    <div className="flex items-center border border-slate-200 rounded-full bg-white shadow-2xs">
                      <button 
                        disabled={detailQuantity <= 1 || selectedProduct.stock <= 0}
                        onClick={() => setDetailQuantity(prev => Math.max(1, prev - 1))}
                        className="w-9 h-9 flex items-center justify-center text-slate-600 hover:bg-slate-100 disabled:opacity-40 disabled:cursor-not-allowed">
                        <Minus className="w-3.5 h-3.5" />
                      </button>
                      <input 
                        type="text" 
                        readOnly 
                        value={selectedProduct.stock > 0 ? detailQuantity : 0}
                        className="w-12 text-center text-xs font-bold text-slate-900 border-none focus:outline-none"
                      />
                      <button 
                        disabled={selectedProduct.stock <= 0 || detailQuantity >= selectedProduct.stock}
                        onClick={() => setDetailQuantity(prev => Math.min(selectedProduct.stock, prev + 1))}
                        className="w-9 h-9 flex items-center justify-center text-slate-600 hover:bg-slate-100 disabled:opacity-40 disabled:cursor-not-allowed">
                        <Plus className="w-3.5 h-3.5" />
                      </button>
                    </div>
                    <span className="text-[11px] text-slate-500">
                      {selectedProduct.stock > 0 ? `Max: ${selectedProduct.stock} units` : 'Unavailable'}
                    </span>
                  </div>

                  {/* Buttons: Add To Cart & Buy Now */}
                  <div className="flex flex-col sm:flex-row gap-3 pt-2">
                    {selectedProduct.stock > 0 ? (
                      <>
                        <button 
                          onClick={() => handleAddToCart(selectedProduct, detailQuantity, false)}
                          className="flex-1 py-3 px-6 rounded-full bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs flex items-center justify-center gap-2 shadow-md shadow-blue-500/20 transition hover:-translate-y-0.5">
                          <ShoppingBag className="w-4 h-4" />
                          <span>Add To Cart ({detailQuantity})</span>
                        </button>
                        <button 
                          onClick={() => handleAddToCart(selectedProduct, detailQuantity, true)}
                          className="flex-1 py-3 px-6 rounded-full bg-slate-900 hover:bg-slate-800 text-white font-bold text-xs flex items-center justify-center gap-2 transition hover:-translate-y-0.5">
                          <Bolt className="w-4 h-4 text-amber-400" />
                          <span>Buy Now</span>
                        </button>
                      </>
                    ) : (
                      <button 
                        disabled 
                        className="w-full py-3 px-6 rounded-full bg-slate-200 text-slate-400 font-bold text-xs flex items-center justify-center gap-2 cursor-not-allowed">
                        <X className="w-4 h-4" />
                        <span>Item Out of Stock</span>
                      </button>
                    )}
                  </div>
                </div>

                {/* Back Link */}
                <div className="pt-4 border-t border-slate-100 flex justify-between items-center">
                  <button 
                    onClick={() => setCurrentPage('products')}
                    className="inline-flex items-center gap-1.5 px-4 py-2 rounded-full border border-slate-200 text-xs font-semibold text-slate-700 hover:bg-slate-100 transition">
                    <ArrowLeft className="w-3.5 h-3.5" /> Back to Products (products.do)
                  </button>
                  <span className="text-[11px] text-slate-400">Product ID: #{selectedProduct.id}</span>
                </div>

              </div>

            </div>
          </div>
        ) : currentPage === 'products' ? (
          /* ============================================================== */
          /* VIEW 6: PRODUCTS CATALOG (products.jsp)                        */
          /* ============================================================== */
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            
            {/* Header & Seller Shortcuts */}
            <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6">
              <div>
                <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">Explore Products</h1>
                <p className="text-slate-500 text-sm mt-0.5">
                  Browse through verified electronics, devices, and computing peripherals
                </p>
              </div>

              <div className="flex items-center gap-2 flex-wrap">
                {activeSession === 'seller' && (
                  <>
                    <button 
                      onClick={() => setFilterMineOnly(!filterMineOnly)}
                      className={`text-xs font-bold px-3 py-1.5 rounded-full border transition ${
                        filterMineOnly 
                          ? 'bg-amber-500 text-white border-amber-600 shadow-sm' 
                          : 'bg-white text-slate-700 border-slate-200 hover:border-amber-400'
                      }`}>
                      {filterMineOnly ? 'Showing My Listings (Demo Seller)' : 'Filter: My Listings Only'}
                    </button>
                    <button 
                      onClick={() => showToast("Opens add_product.do")}
                      className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full bg-blue-600 hover:bg-blue-700 text-white text-xs font-bold shadow-sm transition">
                      <PlusCircle className="w-3.5 h-3.5" /> Add Listing (add_product.do)
                    </button>
                  </>
                )}
              </div>
            </div>

            {/* Filter & Search Toolbar */}
            <div className="bg-white border border-slate-200 rounded-2xl p-4 sm:p-5 mb-8 shadow-xs space-y-4">
              <div className="flex flex-col md:flex-row gap-3">
                <div className="flex-1 relative">
                  <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                  <input
                    type="text"
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    placeholder="Search by product name or keyword..."
                    className="w-full bg-slate-50 pl-10 pr-4 py-2 rounded-xl border border-slate-200 text-xs focus:outline-none focus:border-blue-500 focus:bg-white transition"
                  />
                  {searchTerm && (
                    <button onClick={() => setSearchTerm('')} className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600">
                      <X className="w-3.5 h-3.5" />
                    </button>
                  )}
                </div>

                <div className="flex items-center gap-2">
                  <div className="flex items-center gap-1.5 bg-slate-50 border border-slate-200 rounded-xl px-3 py-1.5 text-xs">
                    <ArrowUpDown className="w-3.5 h-3.5 text-slate-500" />
                    <select
                      value={selectedSort}
                      onChange={(e) => setSelectedSort(e.target.value)}
                      className="bg-transparent text-slate-700 font-semibold focus:outline-none text-xs cursor-pointer">
                      <option value="newest">Newest First</option>
                      <option value="price_asc">Price: Low to High</option>
                      <option value="price_desc">Price: High to Low</option>
                      <option value="discount">Biggest Discount</option>
                      <option value="stock">High Stock</option>
                      <option value="name_asc">Name: A to Z</option>
                    </select>
                  </div>

                  {(searchTerm || selectedCategory !== 'All' || filterMineOnly || selectedSort !== 'newest') && (
                    <button
                      onClick={() => {
                        setSearchTerm('');
                        setSelectedCategory('All');
                        setFilterMineOnly(false);
                        setSelectedSort('newest');
                      }}
                      className="inline-flex items-center gap-1 text-xs text-slate-500 hover:text-rose-600 px-3 py-2 rounded-xl hover:bg-slate-100 transition">
                      <ResetIcon className="w-3.5 h-3.5" /> Reset
                    </button>
                  )}
                </div>
              </div>

              {/* Category Pills */}
              <div className="flex items-center gap-2 overflow-x-auto pb-1">
                <span className="text-xs font-bold text-slate-400 uppercase tracking-wider text-[10px] shrink-0 mr-1">
                  Category:
                </span>
                {categories.map((cat) => (
                  <button
                    key={cat}
                    onClick={() => setSelectedCategory(cat)}
                    className={`px-3 py-1.5 rounded-full text-xs font-semibold shrink-0 transition ${
                      selectedCategory === cat
                        ? 'bg-blue-600 text-white shadow-xs'
                        : 'bg-slate-100 text-slate-600 hover:bg-slate-200'
                    }`}>
                    {cat}
                  </button>
                ))}
              </div>
            </div>

            {/* Product Grid */}
            {filteredProducts.length === 0 ? (
              <div className="bg-white rounded-3xl border border-slate-200 p-12 text-center my-6">
                <div className="w-12 h-12 rounded-full bg-slate-100 text-slate-400 flex items-center justify-center mx-auto mb-3">
                  <Search className="w-6 h-6" />
                </div>
                <h3 className="text-base font-bold text-slate-800">No products match your criteria</h3>
                <p className="text-xs text-slate-500 mt-1 max-w-sm mx-auto">
                  Try adjusting your search terms, changing the category filter, or resetting filters.
                </p>
                <button
                  onClick={() => { setSearchTerm(''); setSelectedCategory('All'); setFilterMineOnly(false); }}
                  className="mt-4 px-4 py-2 rounded-full bg-blue-600 text-white text-xs font-bold">
                  Clear All Filters
                </button>
              </div>
            ) : (
              <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
                {filteredProducts.map((product) => {
                  const isOwnedByMe = activeSession === 'seller' && product.sellerId === 1;

                  return (
                    <div 
                      key={product.id}
                      className="bg-white border border-slate-200 rounded-2xl overflow-hidden shadow-xs hover:shadow-xl transition-all duration-300 flex flex-col group hover:-translate-y-1">
                      
                      {/* Card Media Header */}
                      <div className="relative aspect-4/3 bg-slate-100 p-4 flex items-center justify-center overflow-hidden">
                        <img 
                          src={product.image} 
                          alt={product.name}
                          className="h-full w-full object-contain group-hover:scale-105 transition duration-300"
                        />
                        
                        {/* Discount Badge */}
                        {product.discount > 0 && (
                          <span className="absolute top-3 left-3 bg-rose-600 text-white font-bold text-[10px] px-2 py-0.5 rounded-full shadow-xs">
                            {product.discount}% OFF
                          </span>
                        )}

                        {/* Stock Badge */}
                        <div className="absolute top-3 right-3">
                          {product.stock > 5 ? (
                            <span className="bg-emerald-50 text-emerald-700 border border-emerald-200 text-[10px] font-bold px-2 py-0.5 rounded-full">
                              In Stock
                            </span>
                          ) : product.stock > 0 ? (
                            <span className="bg-amber-50 text-amber-700 border border-amber-200 text-[10px] font-bold px-2 py-0.5 rounded-full">
                              Low Stock ({product.stock})
                            </span>
                          ) : (
                            <span className="bg-rose-50 text-rose-700 border border-rose-200 text-[10px] font-bold px-2 py-0.5 rounded-full">
                              Out of Stock
                            </span>
                          )}
                        </div>
                      </div>

                      {/* Card Content Body */}
                      <div className="p-4 sm:p-5 flex-1 flex flex-col justify-between space-y-4">
                        <div className="space-y-2">
                          <div className="flex items-center justify-between text-[11px] text-slate-500">
                            <span className="font-semibold text-blue-600 bg-blue-50 px-2 py-0.5 rounded">
                              {product.category}
                            </span>
                            <span className="truncate max-w-[130px]" title={`Seller: ${product.seller}`}>
                              By {product.seller}
                            </span>
                          </div>

                          <h3 
                            onClick={() => handleOpenDetail(product)}
                            className="font-bold text-sm text-slate-900 group-hover:text-blue-600 transition line-clamp-2 leading-snug cursor-pointer">
                            {product.name}
                          </h3>

                          <p className="text-slate-500 text-xs line-clamp-2 leading-relaxed">
                            {product.description}
                          </p>
                        </div>

                        {/* Pricing & Rating Row */}
                        <div className="pt-2 border-t border-slate-100">
                          <div className="flex items-baseline justify-between mb-3">
                            <div className="flex items-baseline gap-2">
                              <span className="text-lg font-black text-slate-900">${product.price}</span>
                              {product.originalPrice > product.price && (
                                <span className="text-xs text-slate-400 line-through">${product.originalPrice}</span>
                              )}
                            </div>
                            <div className="flex items-center gap-1 text-[11px] text-amber-500 font-bold">
                              <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />
                              <span>{product.rating}</span>
                              <span className="text-slate-400 font-normal">({product.reviews})</span>
                            </div>
                          </div>

                          {/* Action Buttons: View Details & Add to Cart */}
                          <div className="flex items-center gap-2">
                            <button
                              onClick={() => handleOpenDetail(product)}
                              className="flex-1 py-2 px-3 rounded-xl border border-slate-200 hover:border-blue-500 hover:text-blue-600 text-slate-700 font-bold text-xs transition">
                              View Details
                            </button>

                            {product.stock > 0 ? (
                              <button
                                onClick={() => handleAddToCart(product, 1, false)}
                                className="py-2 px-3 rounded-xl bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs flex items-center justify-center gap-1.5 shadow-sm transition"
                                title="Add to Cart">
                                <ShoppingBag className="w-3.5 h-3.5" />
                                <span>Add to Cart</span>
                              </button>
                            ) : (
                              <button
                                disabled
                                className="py-2 px-3 rounded-xl bg-slate-100 text-slate-400 font-bold text-xs cursor-not-allowed">
                                Sold Out
                              </button>
                            )}
                          </div>

                          {/* Seller Management Controls */}
                          {isOwnedByMe && (
                            <div className="mt-3 pt-3 border-t border-dashed border-slate-200 flex items-center justify-between text-xs">
                              <span className="text-[10px] font-bold text-amber-700 bg-amber-50 px-2 py-0.5 rounded">
                                My Product (Seller #1)
                              </span>
                              <div className="flex items-center gap-1">
                                <button
                                  onClick={() => setUploadModalProduct(product)}
                                  className="p-1.5 rounded-lg text-blue-600 hover:bg-blue-50 transition"
                                  title="Upload Photos (product_pic.do)">
                                  <Camera className="w-4 h-4" />
                                </button>
                                <button
                                  onClick={() => showToast(`Edit Product #${product.id} modal/route`)}
                                  className="p-1.5 rounded-lg text-slate-600 hover:bg-slate-100 transition"
                                  title="Edit Product Details">
                                  <Edit3 className="w-4 h-4" />
                                </button>
                                <button
                                  onClick={() => showToast(`Delete Product #${product.id} prompt`)}
                                  className="p-1.5 rounded-lg text-rose-600 hover:bg-rose-50 transition"
                                  title="Delete Product">
                                  <Trash2 className="w-4 h-4" />
                                </button>
                              </div>
                            </div>
                          )}

                        </div>

                      </div>
                    </div>
                  );
                })}
              </div>
            )}

          </div>
        ) : (
          /* ============================================================== */
          /* VIEW 7: HOMEPAGE (index.jsp)                                   */
          /* ============================================================== */
          <div className="space-y-16 pb-16">
            
            {/* Hero Section */}
            <section className="relative overflow-hidden bg-gradient-to-b from-blue-900 via-slate-900 to-slate-950 text-white py-20 lg:py-28">
              <div className="absolute inset-0 opacity-10 bg-[radial-gradient(#3b82f6_1px,transparent_1px)] [background-size:16px_16px]"></div>
              
              <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div className="grid grid-cols-1 lg:grid-cols-12 gap-12 items-center">
                  <div className="lg:col-span-7 space-y-6 text-center lg:text-left">
                    <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-500/10 border border-blue-400/20 text-blue-400 text-xs font-bold tracking-wide uppercase">
                      <Sparkles className="w-3.5 h-3.5" /> Next-Gen E-Commerce Architecture
                    </div>
                    <h1 className="text-3xl sm:text-5xl lg:text-6xl font-black tracking-tight leading-tight">
                      Engineered for <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-400 to-indigo-300">Pure Performance</span> &amp; Scale.
                    </h1>
                    <p className="text-sm sm:text-base text-slate-300 max-w-2xl mx-auto lg:mx-0 leading-relaxed font-normal">
                      Experience seamless shopping backed by Java Servlet 3.1, robust JDBC connection pooling, and optimized MySQL catalog queries.
                    </p>
                    <div className="flex flex-col sm:flex-row gap-3 pt-2 justify-center lg:justify-start">
                      <button 
                        onClick={() => setCurrentPage('products')}
                        className="px-6 py-3 rounded-full bg-blue-600 hover:bg-blue-500 text-white font-bold text-xs shadow-lg shadow-blue-600/30 flex items-center justify-center gap-2 transition hover:-translate-y-0.5">
                        <ShoppingBag className="w-4 h-4" /> Browse Catalog (products.do)
                      </button>
                      <button 
                        onClick={() => { setActiveSession('seller'); showToast("Switched to Seller Central Mode"); }}
                        className="px-6 py-3 rounded-full bg-slate-800 hover:bg-slate-700 text-slate-200 font-bold text-xs border border-slate-700 flex items-center justify-center gap-2 transition hover:-translate-y-0.5">
                        <Tag className="w-4 h-4 text-amber-400" /> Start Selling Today
                      </button>
                    </div>
                  </div>

                  <div className="lg:col-span-5 flex justify-center">
                    <div className="relative w-full max-w-md bg-gradient-to-tr from-blue-600/20 to-purple-600/20 rounded-3xl p-6 border border-white/10 backdrop-blur-md shadow-2xl">
                      <div className="aspect-square rounded-2xl overflow-hidden bg-slate-900/60 p-4 flex items-center justify-center">
                        <img 
                          src="https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80" 
                          alt="Sony WH-1000XM5" 
                          className="h-56 object-contain"
                        />
                      </div>
                      <div className="pt-4 space-y-2">
                        <h3 className="font-bold text-base text-white">
                          Sony WH-1000XM5 Wireless Headphones
                        </h3>
                        <div className="flex justify-between items-center pt-2">
                          <span className="text-2xl font-black text-white">$314</span>
                          <button 
                            onClick={() => handleOpenDetail(INITIAL_PRODUCTS[0])}
                            className="px-4 py-2 rounded-full bg-blue-600 hover:bg-blue-500 text-white text-xs font-bold transition">
                            View Details
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </section>

            {/* Highlights Grid */}
            <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
              <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
                <div className="p-6 rounded-2xl bg-white border border-slate-200/80 shadow-xs flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-blue-50 text-blue-600 flex items-center justify-center shrink-0">
                    <Truck className="w-6 h-6" />
                  </div>
                  <div>
                    <h4 className="font-bold text-sm text-slate-900">Express Delivery</h4>
                    <p className="text-xs text-slate-500">Free shipping on orders over $50</p>
                  </div>
                </div>

                <div className="p-6 rounded-2xl bg-white border border-slate-200/80 shadow-xs flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-emerald-50 text-emerald-600 flex items-center justify-center shrink-0">
                    <ShieldCheck className="w-6 h-6" />
                  </div>
                  <div>
                    <h4 className="font-bold text-sm text-slate-900">Buyer Protection</h4>
                    <p className="text-xs text-slate-500">100% money back guarantee</p>
                  </div>
                </div>

                <div className="p-6 rounded-2xl bg-white border border-slate-200/80 shadow-xs flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-purple-50 text-purple-600 flex items-center justify-center shrink-0">
                    <RotateCcw className="w-6 h-6" />
                  </div>
                  <div>
                    <h4 className="font-bold text-sm text-slate-900">30-Day Returns</h4>
                    <p className="text-xs text-slate-500">Hassle-free replacement policy</p>
                  </div>
                </div>

                <div className="p-6 rounded-2xl bg-white border border-slate-200/80 shadow-xs flex items-center gap-4">
                  <div className="w-12 h-12 rounded-xl bg-amber-50 text-amber-600 flex items-center justify-center shrink-0">
                    <Headset className="w-6 h-6" />
                  </div>
                  <div>
                    <h4 className="font-bold text-sm text-slate-900">24/7 Support</h4>
                    <p className="text-xs text-slate-500">Dedicated customer care team</p>
                  </div>
                </div>
              </div>
            </section>
          </div>
        )}

      </main>

      {/* Modern Reusable Footer (footer.jsp) */}
      <footer className="bg-slate-950 text-slate-400 pt-16 pb-12 border-t border-slate-900">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-10 pb-12 border-b border-slate-800">
            <div className="lg:col-span-2 space-y-4">
              <div className="flex items-center gap-2.5">
                <div className="w-9 h-9 rounded-xl bg-blue-600 flex items-center justify-center text-white font-bold">
                  <ShoppingBag className="w-5 h-5" />
                </div>
                <span className="text-2xl font-black text-white tracking-tight">
                  Cart<span className="text-blue-500">Nova</span>
                </span>
              </div>
              <p className="text-xs text-slate-400 leading-relaxed max-w-sm">
                Next-generation Java JSP/Servlet/JDBC e-commerce platform. Delivering high performance electronics with transparent buyer protections and verified seller fulfillment.
              </p>
              <div className="flex items-center gap-2 pt-2">
                <span className="text-xs font-semibold text-slate-300">Architecture:</span>
                <span className="text-[11px] bg-slate-900 border border-slate-800 text-blue-400 font-mono px-2 py-0.5 rounded">
                  JSP + Servlet + JDBC + MySQL
                </span>
              </div>
            </div>

            <div>
              <h4 className="text-white text-xs font-bold uppercase tracking-wider mb-4">Shop &amp; Explore</h4>
              <ul className="space-y-2.5 text-xs">
                <li><button onClick={() => { setCurrentPage('products'); window.scrollTo({ top: 0, behavior: 'smooth' }); }} className="hover:text-white transition">All Products (products.do)</button></li>
                <li><button onClick={() => { setSelectedCategory('Audio'); setCurrentPage('products'); window.scrollTo({ top: 0, behavior: 'smooth' }); }} className="hover:text-white transition">Audio Systems</button></li>
                <li><button onClick={() => { setSelectedCategory('Wearables'); setCurrentPage('products'); window.scrollTo({ top: 0, behavior: 'smooth' }); }} className="hover:text-white transition">Wearables &amp; Watches</button></li>
                <li><button onClick={() => { setSelectedCategory('Monitors'); setCurrentPage('products'); window.scrollTo({ top: 0, behavior: 'smooth' }); }} className="hover:text-white transition">4K Displays</button></li>
              </ul>
            </div>

            <div>
              <h4 className="text-white text-xs font-bold uppercase tracking-wider mb-4">Customer Care</h4>
              <ul className="space-y-2.5 text-xs">
                <li><button onClick={() => { setCurrentPage('signin'); window.scrollTo({ top: 0, behavior: 'smooth' }); }} className="hover:text-white transition">Sign In (signin.jsp)</button></li>
                <li><button onClick={() => { setCurrentPage('signup'); window.scrollTo({ top: 0, behavior: 'smooth' }); }} className="hover:text-white transition">Create Account (signup.jsp)</button></li>
                <li><button onClick={() => showToast("Opens user_profile.do")} className="hover:text-white transition">My Profile (user_profile.do)</button></li>
                <li><button onClick={() => showToast("Opens dashboard.jsp")} className="hover:text-white transition">Dashboard.jsp</button></li>
              </ul>
            </div>

            <div>
              <h4 className="text-white text-xs font-bold uppercase tracking-wider mb-4">Authentication Endpoints</h4>
              <div className="space-y-1.5 text-xs font-mono text-slate-400">
                <div>&bull; SignIn.java (/signin.do)</div>
                <div>&bull; SignUp.java (/signup.do)</div>
                <div>&bull; CheckEmail.java (/check_email_exists.do)</div>
                <div>&bull; SignOut.java (/signout.do)</div>
              </div>
            </div>
          </div>

          <div className="pt-8 flex flex-col sm:flex-row justify-between items-center gap-4 text-xs text-slate-500">
            <div>
              &copy; {new Date().getFullYear()} CartNova E-Commerce. All rights reserved. Built with Java JSP, Servlet, JDBC &amp; MySQL.
            </div>
            <div className="flex items-center gap-2 flex-wrap">
              <span className="bg-slate-900 border border-slate-800 text-slate-300 px-2.5 py-1 rounded text-[11px] font-semibold">Visa</span>
              <span className="bg-slate-900 border border-slate-800 text-slate-300 px-2.5 py-1 rounded text-[11px] font-semibold">MasterCard</span>
              <span className="bg-slate-900 border border-slate-800 text-slate-300 px-2.5 py-1 rounded text-[11px] font-semibold">AmEx</span>
              <span className="bg-slate-900 border border-slate-800 text-slate-300 px-2.5 py-1 rounded text-[11px] font-semibold">PayPal</span>
              <span className="bg-slate-900 border border-slate-800 text-slate-300 px-2.5 py-1 rounded text-[11px] font-semibold">COD</span>
            </div>
          </div>
        </div>
      </footer>

    </div>
  );
}
