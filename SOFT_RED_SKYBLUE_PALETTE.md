# 🎨 Soft Red & Sky Blue - Minimalistic Color Palette

## Color Palette Details

### **Primary Colors (Soft Red)**
```dart
Primary:      #EF4444  // red-500 (vibrant red)
Primary Light:#F87171  // red-400 (soft red)
Primary Dark: #DC2626  // red-600 (deep red)
```

### **Secondary Colors (Sky Blue)**
```dart
Secondary:      #0EA5E9  // sky-500 (vibrant sky blue)
Secondary Light:#38BDF8  // sky-400 (light sky blue)
Secondary Dark: #0284C7  // sky-600 (deep sky blue)
```

### **Neutral Colors**
```dart
Background:     #FFFFFF  // Pure white
Surface:        #F9FAFB  // Very light gray (gray-50)
Card Background:#FFFFFF  // White cards
Border:         #E5E7EB  // Light gray (gray-200)
Border Light:   #F3F4F6  // Very light gray (gray-100)
```

### **Text Colors**
```dart
Text Primary:   #111827  // Almost black (gray-900)
Text Secondary: #6B7280  // Medium gray (gray-500)
Text Light:     #9CA3AF  // Light gray (gray-400)
```

### **Status Colors**
```dart
Success:        #10B981  // green-500
Success Light:  #34D399  // green-400
Warning:        #F59E0B  // amber-500
Error:          #EF4444  // red-500 (same as primary)
Info:           #0EA5E9  // sky-500 (same as secondary)
```

### **Shadow Colors**
```dart
Shadow:         rgba(0, 0, 0, 0.05)   // Very subtle
Shadow Light:   rgba(0, 0, 0, 0.02)   // Extra subtle
```

---

## Visual Examples

### Gradient Options for Balance Card
```dart
// Option 1: Red to Light Red
LinearGradient(
  colors: [#F87171, #EF4444],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)

// Option 2: Sky Blue to Deep Blue  
LinearGradient(
  colors: [#38BDF8, #0284C7],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)

// Option 3: Red to Sky Blue (Recommended!)
LinearGradient(
  colors: [#EF4444, #0EA5E9],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)
```

---

## Usage Guidelines

### Primary (Soft Red) - Use for:
- Primary buttons (CTAs)
- Important actions
- Active states
- Highlights
- Error messages

### Secondary (Sky Blue) - Use for:
- Secondary buttons
- Information displays
- Links
- Icons
- Accents

### Neutral (White/Gray) - Use for:
- Backgrounds
- Cards
- Borders
- Subtle elements

---

## Color Psychology

**Soft Red (#EF4444):**
- Energy, passion, action
- Urgency without aggression
- Financial growth, prosperity
- Attention-grabbing but professional

**Sky Blue (#0EA5E9):**
- Trust, stability, security
- Peace, calmness
- Technology, innovation
- Perfect for financial apps

**Together:**
- Modern, energetic, trustworthy
- Balanced (warm + cool)
- Professional yet approachable
- Perfect for fintech/banking
