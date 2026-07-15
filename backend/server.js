const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const JWT_SECRET = "super_secret_key_for_myservice";

// قاعدة بيانات مؤقتة في الذاكرة للتجربة والديمو
const users = [];
const orders = [];

// 1. تسجيل مستخدم جديد
app.post('/api/auth/register', (req, res) => {
    const { fullName, phone, password, role } = req.body;
    if (!fullName || !phone || !password || !role) {
        return res.status(400).json({ message: "جميع الحقول مطلوبة" });
    }
    const userExists = users.find(u => u.phone === phone);
    if (userExists) {
        return res.status(400).json({ message: "هذا الرقم مسجل بالفعل" });
    }
    const hashedPassword = bcrypt.hashSync(password, 10);
    const newUser = { id: users.length + 1, fullName, phone, password: hashedPassword, role };
    users.push(newUser);
    res.status(201).json({ message: "تم التسجيل بنجاح", user: { id: newUser.id, fullName, phone, role } });
});

// 2. تسجيل الدخول
app.post('/api/auth/login', (req, res) => {
    const { phone, password } = req.body;
    const user = users.find(u => u.phone === phone);
    if (!user || !bcrypt.compareSync(password, user.password)) {
        return res.status(401).json({ message: "بيانات الدخول غير صحيحة" });
    }
    const token = jwt.sign({ id: user.id, role: user.role }, JWT_SECRET, { expiresIn: '24h' });
    res.json({ token, user: { id: user.id, fullName: user.fullName, role: user.role } });
});

// Middleware للتحقق من التوكن (VIP Pass)
function authenticateToken(req, res, next) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) return res.sendStatus(401);
    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) return res.sendStatus(403);
        req.user = user;
        next();
    });
}

// 3. إنشاء طلب جديد (خاص بالزبون)
app.post('/api/orders', authenticateToken, (req, res) => {
    const { title, description, city } = req.body;
    const newOrder = {
        id: orders.length + 1,
        customerId: req.user.id,
        title,
        description,
        city,
        status: "PENDING"
    };
    orders.push(newOrder);
    res.status(201).json({ message: "تم إنشاء الطلب بنجاح", order: newOrder });
});

// 4. جلب الطلبات (للفني أو الزبون)
app.get('/api/orders', authenticateToken, (req, res) => {
    res.json({ orders });
});

app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
