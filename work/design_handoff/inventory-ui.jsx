// FullTank inventory shared components
// Depends on: fulltank-ui.jsx (FT, getFT, Icon, TextField, PrimaryButton, ...)

const FT_STATUS = {
  ok: '#10B981',
  okSoft: '#ECFDF5',
  warn: '#F59E0B',
  warnSoft: '#FFFBEB',
  crit: '#EF4444',
  critSoft: '#FEF2F2',
};

// Choose status by percentage
function levelStatus(pct) {
  if (pct >= 40) return 'ok';
  if (pct >= 20) return 'warn';
  return 'crit';
}
function statusLabel(s) {
  return { ok: 'Optimal', warn: 'Warning', crit: 'Critical' }[s] || s;
}
function statusColor(s) {
  return { ok: FT_STATUS.ok, warn: FT_STATUS.warn, crit: FT_STATUS.crit }[s];
}
function statusSoft(s) {
  return { ok: FT_STATUS.okSoft, warn: FT_STATUS.warnSoft, crit: FT_STATUS.critSoft }[s];
}

// ─── Inventory Icons ────────────────────────────────────────
const InvIcon = {
  tank: (c = 'currentColor') => (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.7" strokeLinecap="round" strokeLinejoin="round">
      <path d="M6 4h12v16a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2V4z"/>
      <ellipse cx="12" cy="4" rx="6" ry="1.5"/>
      <path d="M6 12h12"/>
    </svg>
  ),
  droplet: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 3 C 12 3, 5 10, 5 15 A 7 7 0 0 0 19 15 C 19 10, 12 3, 12 3z"/>
    </svg>
  ),
  bell: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M6 8a6 6 0 1 1 12 0c0 7 3 7 3 9H3c0-2 3-2 3-9z"/>
      <path d="M10 21a2 2 0 0 0 4 0"/>
    </svg>
  ),
  alert: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 3 L22 20 H2 z"/>
      <path d="M12 10v5M12 18v.01"/>
    </svg>
  ),
  pin: (c = 'currentColor') => (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 22s7-6 7-12a7 7 0 0 0-14 0c0 6 7 12 7 12z"/>
      <circle cx="12" cy="10" r="2.5"/>
    </svg>
  ),
  radio: (c = 'currentColor') => (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="2"/>
      <path d="M7.05 16.95a7 7 0 0 1 0-9.9M16.95 7.05a7 7 0 0 1 0 9.9"/>
      <path d="M3.51 20.49a12 12 0 0 1 0-16.98M20.49 3.51a12 12 0 0 1 0 16.98"/>
    </svg>
  ),
  thermo: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M10 4a2 2 0 1 1 4 0v10.5a4 4 0 1 1-4 0z"/>
      <path d="M12 14V8"/>
    </svg>
  ),
  gauge: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M4 15a8 8 0 1 1 16 0"/>
      <path d="M12 15l4-4"/>
      <circle cx="12" cy="15" r="1.5" fill={c}/>
    </svg>
  ),
  clock: (c = 'currentColor') => (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="12" r="9"/>
      <path d="M12 7v5l3 2"/>
    </svg>
  ),
  filter: (c = 'currentColor') => (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M4 5h16l-6 8v6l-4-2v-4z"/>
    </svg>
  ),
  search: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="11" cy="11" r="7"/>
      <path d="M20 20l-3.5-3.5"/>
    </svg>
  ),
  chevron: (c = 'currentColor') => (
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M9 6l6 6-6 6"/>
    </svg>
  ),
  plus: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round">
      <path d="M12 5v14M5 12h14"/>
    </svg>
  ),
  home: (c = 'currentColor') => (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M3 11l9-7 9 7v9a2 2 0 0 1-2 2h-4v-6h-6v6H5a2 2 0 0 1-2-2z"/>
    </svg>
  ),
  list: (c = 'currentColor') => (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M4 6h16M4 12h16M4 18h16"/>
    </svg>
  ),
  chart2: (c = 'currentColor') => (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M4 20h16"/>
      <rect x="6" y="10" width="3" height="10" rx="1"/>
      <rect x="11" y="6" width="3" height="14" rx="1"/>
      <rect x="16" y="13" width="3" height="7" rx="1"/>
    </svg>
  ),
  userNav: (c = 'currentColor') => (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="12" cy="8" r="4"/><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"/>
    </svg>
  ),
  fuel: (c = 'currentColor') => (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <rect x="4" y="4" width="10" height="17" rx="1"/>
      <path d="M14 10h3v6a2 2 0 0 0 2 2v-9l-3-3"/>
    </svg>
  ),
  send: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <path d="M22 2 11 13"/>
      <path d="M22 2 15 22 11 13 2 9z"/>
    </svg>
  ),
  cal: (c = 'currentColor') => (
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke={c} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round">
      <rect x="3" y="5" width="18" height="16" rx="2"/>
      <path d="M3 10h18M8 3v4M16 3v4"/>
    </svg>
  ),
};

// ─── Status Pill ────────────────────────────────────────────
function StatusPill({ status, label, dot = true, size = 'sm' }) {
  const c = statusColor(status);
  const bg = statusSoft(status);
  const isMd = size === 'md';
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 6,
      padding: isMd ? '5px 10px' : '3px 8px',
      background: bg, color: c,
      borderRadius: 999,
      fontSize: isMd ? 12 : 11, fontWeight: 700,
      letterSpacing: 0.2,
    }}>
      {dot && (
        <span style={{
          width: 6, height: 6, borderRadius: 999, background: c,
        }}/>
      )}
      {label || statusLabel(status)}
    </span>
  );
}

// ─── Horizontal Level Bar ───────────────────────────────────
function LevelBar({ pct, height = 6 }) {
  const s = levelStatus(pct);
  const c = statusColor(s);
  return (
    <div style={{
      width: '100%', height, borderRadius: 999,
      background: FT.line, overflow: 'hidden',
    }}>
      <div style={{
        width: `${Math.max(2, pct)}%`, height: '100%',
        background: c, borderRadius: 999,
        transition: 'width .4s',
      }}/>
    </div>
  );
}

// ─── Tank List Row ──────────────────────────────────────────
function TankRow({ tank, onClick }) {
  const s = levelStatus(tank.pct);
  const c = statusColor(s);
  const { navy, radius } = getFT();
  return (
    <button onClick={onClick} style={{
      width: '100%', textAlign: 'left', cursor: 'pointer',
      padding: 14, borderRadius: radius,
      background: '#fff', border: `1px solid ${FT.line}`,
      display: 'flex', gap: 12, alignItems: 'center',
      fontFamily: 'inherit',
    }}>
      {/* Tank icon w/ colored ring */}
      <div style={{
        width: 44, height: 44, borderRadius: 12, flexShrink: 0,
        background: statusSoft(s), color: c,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>{InvIcon.tank(c)}</div>

      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'baseline', gap: 8 }}>
          <div style={{
            fontSize: 14, fontWeight: 700, color: navy,
            whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
          }}>{tank.name}</div>
          <div style={{ fontSize: 14, fontWeight: 800, color: c, flexShrink: 0 }}>{tank.pct}%</div>
        </div>
        <div style={{
          fontSize: 11, color: FT.inkMid, marginTop: 2,
          display: 'flex', alignItems: 'center', gap: 6,
        }}>
          {InvIcon.pin(FT.inkMid)} <span>{tank.location}</span>
          <span style={{ color: FT.inkSoft }}>·</span>
          <span>{tank.type}</span>
        </div>
        <div style={{ marginTop: 8, display: 'flex', alignItems: 'center', gap: 8 }}>
          <div style={{ flex: 1 }}><LevelBar pct={tank.pct}/></div>
          <div style={{
            fontSize: 10, color: FT.inkSoft, fontWeight: 600, letterSpacing: 0.3,
            display: 'inline-flex', alignItems: 'center', gap: 3,
          }}>
            {InvIcon.radio(s === 'crit' ? c : FT.inkSoft)}
            <span style={{ color: s === 'crit' ? c : FT.inkSoft }}>LIVE</span>
          </div>
        </div>
      </div>
    </button>
  );
}

// ─── Radial Gauge (SVG) ─────────────────────────────────────
function RadialGauge({ pct, size = 200, label }) {
  const s = levelStatus(pct);
  const c = statusColor(s);
  const r = (size / 2) - 16;
  const cir = 2 * Math.PI * r;
  const arcLen = cir * 0.75; // 270° arc
  const fill = arcLen * (pct / 100);
  const { navy } = getFT();
  return (
    <div style={{ position: 'relative', width: size, height: size }}>
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}
        style={{ transform: 'rotate(135deg)', transformOrigin: 'center' }}>
        {/* track */}
        <circle cx={size/2} cy={size/2} r={r}
          fill="none" stroke={FT.line} strokeWidth={12} strokeLinecap="round"
          strokeDasharray={`${arcLen} ${cir}`}/>
        {/* fill */}
        <circle cx={size/2} cy={size/2} r={r}
          fill="none" stroke={c} strokeWidth={12} strokeLinecap="round"
          strokeDasharray={`${fill} ${cir}`}
          style={{ transition: 'stroke-dasharray .6s' }}/>
      </svg>
      {/* Center content */}
      <div style={{
        position: 'absolute', inset: 0,
        display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'center', gap: 4,
      }}>
        <div style={{ fontSize: 44, fontWeight: 800, color: navy, letterSpacing: -1.5, lineHeight: 1 }}>
          {pct}<span style={{ fontSize: 20, color: FT.inkSoft, fontWeight: 600 }}>%</span>
        </div>
        {label && (
          <div style={{ fontSize: 11, color: FT.inkMid, letterSpacing: 0.8, fontWeight: 600, textTransform: 'uppercase' }}>
            {label}
          </div>
        )}
        <div style={{ marginTop: 6 }}>
          <StatusPill status={s} size="md"/>
        </div>
      </div>
    </div>
  );
}

// ─── Telemetry Metric Card ──────────────────────────────────
function MetricCard({ icon, label, value, unit, status = 'ok', trend }) {
  const c = statusColor(status);
  const { navy, radius } = getFT();
  return (
    <div style={{
      padding: 12, borderRadius: radius,
      background: '#fff', border: `1px solid ${FT.line}`,
      display: 'flex', flexDirection: 'column', gap: 8,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <div style={{
          width: 30, height: 30, borderRadius: 8,
          background: statusSoft(status), color: c,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>{icon(c)}</div>
        {trend && (
          <span style={{ fontSize: 11, fontWeight: 700, color: c }}>{trend}</span>
        )}
      </div>
      <div>
        <div style={{ fontSize: 10.5, color: FT.inkMid, letterSpacing: 0.5, fontWeight: 600, textTransform: 'uppercase' }}>
          {label}
        </div>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 4, marginTop: 2 }}>
          <div style={{ fontSize: 20, fontWeight: 800, color: navy, letterSpacing: -0.4 }}>{value}</div>
          {unit && <div style={{ fontSize: 11, color: FT.inkSoft, fontWeight: 600 }}>{unit}</div>}
        </div>
      </div>
    </div>
  );
}

// ─── Bottom Tab Nav ─────────────────────────────────────────
function BottomNav({ active = 'inventory' }) {
  const { navy, blue } = getFT();
  const items = [
    { id: 'home', label: 'Home', icon: InvIcon.home },
    { id: 'inventory', label: 'Inventory', icon: InvIcon.tank },
    { id: 'alerts', label: 'Alerts', icon: InvIcon.bell, badge: 3 },
    { id: 'reports', label: 'Reports', icon: InvIcon.chart2 },
    { id: 'me', label: 'Account', icon: InvIcon.userNav },
  ];
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0,
      background: '#fff', borderTop: `1px solid ${FT.line}`,
      padding: '10px 8px 22px',
      display: 'flex', justifyContent: 'space-around',
      zIndex: 10,
    }}>
      {items.map(it => {
        const isActive = it.id === active;
        const color = isActive ? blue : FT.inkSoft;
        return (
          <button key={it.id} style={{
            flex: 1, background: 'transparent', border: 'none', cursor: 'pointer',
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 3,
            fontFamily: 'inherit', color, padding: 4,
            position: 'relative',
          }}>
            <div style={{ position: 'relative' }}>
              {it.icon(color)}
              {it.badge && (
                <span style={{
                  position: 'absolute', top: -4, right: -6,
                  width: 15, height: 15, borderRadius: 999,
                  background: FT_STATUS.crit, color: '#fff',
                  fontSize: 9, fontWeight: 800,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>{it.badge}</span>
              )}
            </div>
            <span style={{ fontSize: 10, fontWeight: isActive ? 700 : 500 }}>{it.label}</span>
          </button>
        );
      })}
    </div>
  );
}

// ─── Screen Shell for inventory (white bg + optional title bar + bottom nav) ─
function InvShell({ title, subtitle, right, back = false, children, activeTab, hasBottomNav = true }) {
  const { navy } = getFT();
  return (
    <div style={{
      minHeight: '100%', background: '#fff',
      fontFamily: `'${getFT().font}', system-ui, sans-serif`,
      color: navy, position: 'relative',
      paddingBottom: hasBottomNav ? 76 : 0,
    }}>
      <div style={{ height: 54 }}/>
      <div style={{
        padding: '4px 20px 8px',
        display: 'flex', alignItems: 'center', gap: 12,
      }}>
        {back && <BackButton/>}
        <div style={{ flex: 1, minWidth: 0 }}>
          {title && (
            <h1 style={{
              margin: 0, fontSize: 22, fontWeight: 700, letterSpacing: -0.5, color: navy,
              whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
            }}>{title}</h1>
          )}
          {subtitle && (
            <div style={{ fontSize: 12, color: FT.inkMid, marginTop: 2 }}>{subtitle}</div>
          )}
        </div>
        {right}
      </div>
      <div style={{ padding: '10px 20px 20px' }}>
        {children}
      </div>
      {hasBottomNav && <BottomNav active={activeTab}/>}
    </div>
  );
}

Object.assign(window, {
  FT_STATUS, levelStatus, statusLabel, statusColor, statusSoft,
  InvIcon, StatusPill, LevelBar, TankRow, RadialGauge, MetricCard,
  BottomNav, InvShell,
});
