// FullTank shared UI primitives — brand v3 (spec-locked)
// Palette: navy #1A202C ink, orange→amber gradient CTA, light-grey #F3F4F6 inputs

const FT = {
  // Brand
  navy: '#1A202C',           // headings / primary ink
  navyMid: '#2D3748',
  blue: '#1E40AF',           // secondary brand (borders/links)
  blueSoft: '#EFF4FF',       // selected role card fill
  // CTA gradient
  ctaFrom: '#FFB300',
  ctaTo: '#FFA500',
  // Neutrals
  inkMid: '#4A5568',
  inkSoft: '#94A3B8',
  line: '#E2E8F0',
  card: '#F3F4F6',
  cardHover: '#EDF0F4',
  bg: '#FFFFFF',
  info: '#DBEAFE',           // light-blue info box
  infoBorder: '#BFDBFE',
  infoInk: '#1E40AF',
};

function getFT() {
  const t = window.__ftTweaks || {};
  return {
    navy: t.navy || FT.navy,
    blue: t.blue || FT.blue,
    ctaFrom: t.ctaFrom || FT.ctaFrom,
    ctaTo: t.ctaTo || FT.ctaTo,
    radius: t.radius ?? 8,
    font: t.font || 'Inter',
  };
}

// ─── Logo ────────────────────────────────────────────────────
function FTLogo({ height = 26, invert = false }) {
  return (
    <img src="assets/fulltank-logo.png" alt="FullTank"
      style={{
        height, width: 'auto', display: 'block',
        filter: invert ? 'brightness(0) invert(1) drop-shadow(0 2px 8px rgba(0,0,0,0.35))' : 'none',
      }}/>
  );
}

// ─── Icons ──────────────────────────────────────────────────
const Icon = {
  mail: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/>
    </svg>
  ),
  lock: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/>
    </svg>
  ),
  user: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="8" r="4"/><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"/>
    </svg>
  ),
  building: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <rect x="4" y="3" width="16" height="18" rx="1"/>
      <path d="M8 7h2M14 7h2M8 11h2M14 11h2M8 15h2M14 15h2"/>
    </svg>
  ),
  id: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <rect x="3" y="5" width="18" height="14" rx="2"/><path d="M7 10h4M7 14h6M15 10h2v4h-2z"/>
    </svg>
  ),
  phone: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M5 4h4l2 5-3 2a12 12 0 0 0 5 5l2-3 5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2z"/>
    </svg>
  ),
  eye: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/>
    </svg>
  ),
  arrow: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M5 12h14M13 6l6 6-6 6"/>
    </svg>
  ),
  back: (c = 'currentColor') => (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M19 12H5M11 6l-6 6 6 6"/>
    </svg>
  ),
  truck: (c = 'currentColor') => (
    <svg width="26" height="26" viewBox="0 0 32 32" fill="none" stroke={c} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
      <rect x="2" y="10" width="15" height="11" rx="1"/>
      <path d="M17 13h6l4 4v4h-10z"/>
      <circle cx="9" cy="24" r="2.5"/><circle cx="22" cy="24" r="2.5"/>
    </svg>
  ),
  chart: (c = 'currentColor') => (
    <svg width="26" height="26" viewBox="0 0 32 32" fill="none" stroke={c} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
      <path d="M4 27h24"/>
      <rect x="7" y="17" width="4" height="10" rx="1"/>
      <rect x="14" y="11" width="4" height="16" rx="1"/>
      <rect x="21" y="6" width="4" height="21" rx="1"/>
    </svg>
  ),
  check: (c = 'currentColor') => (
    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="3.5" strokeLinecap="round" strokeLinejoin="round">
      <path d="M5 12l5 5L20 7"/>
    </svg>
  ),
  shield: (c = 'currentColor') => (
    <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 2l9 4v6c0 5-3.9 9.4-9 10-5.1-.6-9-5-9-10V6l9-4z"/>
      <path d="M9 12l2 2 4-4"/>
    </svg>
  ),
  info: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="10"/><path d="M12 8v.01M11 12h1v5h1"/>
    </svg>
  ),
  help: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="10"/>
      <path d="M9.5 9a2.5 2.5 0 0 1 5 0c0 1.5-2.5 2-2.5 3.5"/>
      <path d="M12 17v.01"/>
    </svg>
  ),
};

// ─── Text Field (light-grey background, 4-8px radius) ──────
function TextField({ label, icon, placeholder, type = 'text', value = '', trailing, error }) {
  const { radius, blue } = getFT();
  const [focus, setFocus] = React.useState(false);
  return (
    <label style={{ display: 'block' }}>
      {label && (
        <div style={{
          fontSize: 11, fontWeight: 600, color: FT.inkMid, marginBottom: 6,
          letterSpacing: 0.3, textTransform: 'uppercase',
        }}>{label}</div>
      )}
      <div style={{
        display: 'flex', alignItems: 'center', gap: 10,
        padding: '0 14px', height: 46,
        background: FT.card,
        border: `1.5px solid ${error ? '#DC2626' : (focus ? blue : FT.line)}`,
        borderRadius: radius,
        transition: 'all .15s',
      }}>
        {icon && <span style={{ display: 'flex', color: focus ? blue : FT.inkSoft }}>
          {icon(focus ? blue : FT.inkSoft)}
        </span>}
        <input
          type={type} placeholder={placeholder} defaultValue={value}
          onFocus={() => setFocus(true)} onBlur={() => setFocus(false)}
          style={{
            flex: 1, border: 'none', outline: 'none', background: 'transparent',
            fontSize: 14, color: FT.navy, fontFamily: 'inherit', minWidth: 0,
            fontWeight: 500,
          }}
        />
        {trailing}
      </div>
    </label>
  );
}

// ─── Primary Button (pill, gradient) ────────────────────────
function PrimaryButton({ children, trailing, onClick }) {
  const { ctaFrom, ctaTo } = getFT();
  return (
    <button onClick={onClick} style={{
      width: '100%', height: 52, border: 'none', cursor: 'pointer',
      background: `linear-gradient(90deg, ${ctaFrom} 0%, ${ctaTo} 100%)`,
      color: '#fff',
      borderRadius: 999, // pill
      fontFamily: 'inherit', fontSize: 15, fontWeight: 700,
      letterSpacing: 0.1,
      display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 10,
      boxShadow: `0 10px 22px -10px ${ctaTo}cc, inset 0 1px 0 rgba(255,255,255,0.35)`,
    }}>
      {children}
      {trailing && <span style={{ display: 'flex' }}>{trailing}</span>}
    </button>
  );
}

// ─── Secondary Button (outlined) ─────────────────────────────
function SecondaryButton({ children, onClick }) {
  const { navy, radius } = getFT();
  return (
    <button onClick={onClick} style={{
      width: '100%', height: 48, cursor: 'pointer',
      background: '#fff', color: navy,
      border: `1.5px solid ${FT.line}`,
      borderRadius: radius,
      fontFamily: 'inherit', fontSize: 14, fontWeight: 600,
    }}>
      {children}
    </button>
  );
}

// ─── Checkbox ───────────────────────────────────────────────
function Checkbox({ checked = false, children, small = false }) {
  const { blue } = getFT();
  const [c, setC] = React.useState(checked);
  const size = small ? 16 : 18;
  return (
    <label onClick={(e) => { e.preventDefault(); setC(!c); }}
      style={{ display: 'flex', alignItems: 'center', gap: 8, cursor: 'pointer', userSelect: 'none' }}>
      <span style={{
        width: size, height: size, borderRadius: 4, flexShrink: 0,
        border: `1.5px solid ${c ? blue : FT.line}`,
        background: c ? blue : '#fff',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        {c && Icon.check('#fff')}
      </span>
      <span style={{ fontSize: small ? 12.5 : 13, color: FT.inkMid, lineHeight: 1.4 }}>
        {children}
      </span>
    </label>
  );
}

// ─── Back Button ─────────────────────────────────────────────
function BackButton({ onDark = false }) {
  return (
    <button style={{
      width: 40, height: 40, borderRadius: 12,
      background: onDark ? 'rgba(255,255,255,0.15)' : FT.card,
      border: onDark ? '1px solid rgba(255,255,255,0.25)' : 'none',
      backdropFilter: onDark ? 'blur(10px)' : 'none',
      color: onDark ? '#fff' : FT.navy,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      cursor: 'pointer', flexShrink: 0,
    }}>{Icon.back(onDark ? '#fff' : FT.navy)}</button>
  );
}

Object.assign(window, {
  FT, getFT, FTLogo, Icon,
  TextField, PrimaryButton, SecondaryButton, Checkbox, BackButton,
});
