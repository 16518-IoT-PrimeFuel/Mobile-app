// FullTank Inventory Module: 4 screens

// ═══ Mock IoT Data ═════════════════════════════════════════
const TANKS = [
  { id: 'A-102', name: 'Diesel Tank A-102', location: 'North Yard · Sector 4', type: 'Diesel', pct: 12, capacity: 12000, unit: 'L', current: 1440, sensor: 'SN-4492', updated: '2 min ago' },
  { id: 'B-05',  name: 'Water Tank B-05',   location: 'Sector 1',              type: 'Coolant', pct: 84, capacity: 50000, unit: 'L', current: 42000, sensor: 'SN-2011', updated: '1 min ago' },
  { id: 'C-12',  name: 'Lube Tank C-12',    location: 'Sector 9',              type: 'Lubricant', pct: 35, capacity: 8000, unit: 'L', current: 2800, sensor: 'SN-8821', updated: '3 min ago' },
  { id: 'A-204', name: 'Diesel Tank A-204', location: 'North Yard · Sector 4', type: 'Diesel', pct: 72, capacity: 15000, unit: 'L', current: 10800, sensor: 'SN-4499', updated: 'just now' },
  { id: 'G-11',  name: 'Propane G-11',      location: 'Sector 6',              type: 'Propane', pct: 18, capacity: 6000, unit: 'L', current: 1080, sensor: 'SN-9002', updated: '5 min ago' },
  { id: 'D-4',   name: 'Hydraulic D-4',     location: 'Sector 2',              type: 'Hydraulic', pct: 58, capacity: 4000, unit: 'L', current: 2320, sensor: 'SN-3355', updated: '4 min ago' },
];

const ALERTS = [
  { id: 1, tank: 'Diesel Tank A-102', level: 12, status: 'crit', location: 'North Yard · Sector 4', time: '2 min ago', eta: '~4h to depletion' },
  { id: 2, tank: 'Propane G-11',      level: 18, status: 'crit', location: 'Sector 6',              time: '5 min ago', eta: '~7h to depletion' },
  { id: 3, tank: 'Lube Tank C-12',    level: 35, status: 'warn', location: 'Sector 9',              time: '12 min ago', eta: '~2 days' },
  { id: 4, tank: 'Coolant B-07',      level: 28, status: 'warn', location: 'Sector 1',              time: '18 min ago', eta: '~1.5 days' },
];

// ═══ 1. INVENTORY LIST ═════════════════════════════════════
function InventoryListScreen() {
  const { navy, blue, radius } = getFT();
  const [filter, setFilter] = React.useState('all');

  const filtered = filter === 'all' ? TANKS
    : filter === 'crit' ? TANKS.filter(t => t.pct < 20)
    : filter === 'warn' ? TANKS.filter(t => t.pct >= 20 && t.pct < 40)
    : TANKS.filter(t => t.pct >= 40);

  // Summary counts
  const critCount = TANKS.filter(t => t.pct < 20).length;
  const warnCount = TANKS.filter(t => t.pct >= 20 && t.pct < 40).length;
  const okCount = TANKS.filter(t => t.pct >= 40).length;

  const Chip = ({ id, label, count, color }) => {
    const active = filter === id;
    return (
      <button onClick={() => setFilter(id)} style={{
        padding: '7px 12px', borderRadius: 999,
        background: active ? navy : FT.card,
        color: active ? '#fff' : navy,
        border: 'none', cursor: 'pointer',
        fontFamily: 'inherit', fontSize: 12, fontWeight: 600,
        display: 'inline-flex', alignItems: 'center', gap: 6,
        flexShrink: 0,
      }}>
        {color && (
          <span style={{ width: 6, height: 6, borderRadius: 999, background: color }}/>
        )}
        {label}
        <span style={{
          fontSize: 11, fontWeight: 700,
          color: active ? 'rgba(255,255,255,0.7)' : FT.inkSoft,
        }}>{count}</span>
      </button>
    );
  };

  return (
    <InvShell
      title="Inventory"
      subtitle={`${TANKS.length} tanks · live IoT`}
      right={
        <button style={{
          width: 40, height: 40, borderRadius: 12,
          background: FT.card, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          cursor: 'pointer', color: navy,
        }}>{InvIcon.search(navy)}</button>
      }
      activeTab="inventory"
    >
      {/* Summary strip */}
      <div style={{
        display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8,
        marginBottom: 14,
      }}>
        {[
          { label: 'Critical', count: critCount, color: FT_STATUS.crit, soft: FT_STATUS.critSoft },
          { label: 'Warning',  count: warnCount, color: FT_STATUS.warn, soft: FT_STATUS.warnSoft },
          { label: 'Optimal',  count: okCount,   color: FT_STATUS.ok,   soft: FT_STATUS.okSoft },
        ].map(s => (
          <div key={s.label} style={{
            padding: '10px 12px', borderRadius: radius,
            background: s.soft,
            border: `1px solid ${s.color}22`,
          }}>
            <div style={{
              fontSize: 10, fontWeight: 700, color: s.color,
              letterSpacing: 0.6, textTransform: 'uppercase',
            }}>{s.label}</div>
            <div style={{ fontSize: 22, fontWeight: 800, color: navy, letterSpacing: -0.5, marginTop: 2 }}>
              {String(s.count).padStart(2, '0')}
            </div>
          </div>
        ))}
      </div>

      {/* Filter chips */}
      <div style={{
        display: 'flex', gap: 6, marginBottom: 12,
        overflowX: 'auto', paddingBottom: 2,
      }}>
        <Chip id="all"  label="All"      count={TANKS.length}/>
        <Chip id="crit" label="Critical" count={critCount} color={FT_STATUS.crit}/>
        <Chip id="warn" label="Warning"  count={warnCount} color={FT_STATUS.warn}/>
        <Chip id="ok"   label="Optimal"  count={okCount}   color={FT_STATUS.ok}/>
      </div>

      {/* Tank list */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
        {filtered.map(t => (
          <TankRow key={t.id} tank={t}/>
        ))}
      </div>
    </InvShell>
  );
}

// ═══ 2. TANK DETAIL ════════════════════════════════════════
function TankDetailScreen() {
  const { navy, blue, radius } = getFT();
  const tank = TANKS[0]; // A-102 critical

  return (
    <InvShell
      title={tank.id}
      subtitle={tank.type}
      back
      activeTab="inventory"
      right={
        <div style={{
          display: 'inline-flex', alignItems: 'center', gap: 5,
          padding: '5px 10px', borderRadius: 999,
          background: FT_STATUS.okSoft, color: FT_STATUS.ok,
          fontSize: 10.5, fontWeight: 700, letterSpacing: 0.4,
        }}>
          <span style={{
            width: 6, height: 6, borderRadius: 999, background: FT_STATUS.ok,
            animation: 'pulse 1.4s ease-in-out infinite',
          }}/>
          LIVE
        </div>
      }
    >
      <style>{`@keyframes pulse { 0%,100% { opacity: 1 } 50% { opacity: .35 } }`}</style>

      {/* Gauge card */}
      <div style={{
        padding: '20px 16px 18px', borderRadius: radius,
        background: '#fff', border: `1px solid ${FT.line}`,
        display: 'flex', flexDirection: 'column', alignItems: 'center',
        marginBottom: 14,
      }}>
        <RadialGauge pct={tank.pct} label="Current level"/>
        <div style={{
          marginTop: 16, width: '100%',
          display: 'flex', justifyContent: 'space-around',
          paddingTop: 14, borderTop: `1px solid ${FT.line}`,
        }}>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: 10, color: FT.inkMid, fontWeight: 600, letterSpacing: 0.5, textTransform: 'uppercase' }}>
              Current
            </div>
            <div style={{ fontSize: 16, fontWeight: 800, color: navy, marginTop: 3 }}>
              {tank.current.toLocaleString()} <span style={{ fontSize: 11, color: FT.inkSoft }}>{tank.unit}</span>
            </div>
          </div>
          <div style={{ width: 1, background: FT.line }}/>
          <div style={{ textAlign: 'center' }}>
            <div style={{ fontSize: 10, color: FT.inkMid, fontWeight: 600, letterSpacing: 0.5, textTransform: 'uppercase' }}>
              Capacity
            </div>
            <div style={{ fontSize: 16, fontWeight: 800, color: navy, marginTop: 3 }}>
              {tank.capacity.toLocaleString()} <span style={{ fontSize: 11, color: FT.inkSoft }}>{tank.unit}</span>
            </div>
          </div>
        </div>
      </div>

      {/* Telemetry section */}
      <div style={{
        fontSize: 11, fontWeight: 700, color: FT.inkMid, letterSpacing: 0.6,
        textTransform: 'uppercase', marginBottom: 8,
      }}>Real-time telemetry</div>

      <div style={{
        display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 8, marginBottom: 14,
      }}>
        <MetricCard icon={InvIcon.thermo} label="Temperature" value="24.3" unit="°C" status="ok"/>
        <MetricCard icon={InvIcon.gauge}  label="Pressure"    value="1.02" unit="atm" status="ok" trend="+0.4%"/>
        <MetricCard icon={InvIcon.droplet} label="Flow rate"  value="0.8" unit="L/h out" status="warn"/>
        <MetricCard icon={InvIcon.clock}  label="ETA to empty" value="~4h" status="crit"/>
      </div>

      {/* Sensor meta */}
      <div style={{
        padding: 12, borderRadius: radius, background: FT.card,
        display: 'flex', justifyContent: 'space-between', alignItems: 'center', gap: 8,
        marginBottom: 14,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{
            width: 32, height: 32, borderRadius: 8, background: '#fff',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            color: blue,
          }}>{InvIcon.radio(blue)}</div>
          <div>
            <div style={{ fontSize: 10, color: FT.inkMid, letterSpacing: 0.4, textTransform: 'uppercase', fontWeight: 600 }}>
              Sensor
            </div>
            <div style={{ fontSize: 13, fontWeight: 700, color: navy }}>{tank.sensor}</div>
          </div>
        </div>
        <div style={{ textAlign: 'right' }}>
          <div style={{ fontSize: 10, color: FT.inkMid, letterSpacing: 0.4, textTransform: 'uppercase', fontWeight: 600 }}>
            Last update
          </div>
          <div style={{ fontSize: 12, fontWeight: 600, color: navy }}>{tank.updated}</div>
        </div>
      </div>

      {/* CTA */}
      <PrimaryButton trailing={Icon.arrow('#fff')}>Request Restock</PrimaryButton>
    </InvShell>
  );
}

// ═══ 3. LOW-LEVEL ALERTS ═══════════════════════════════════
function AlertsScreen() {
  const { navy, radius } = getFT();
  const crit = ALERTS.filter(a => a.status === 'crit');
  const warn = ALERTS.filter(a => a.status === 'warn');

  const AlertRow = ({ a }) => {
    const c = statusColor(a.status);
    return (
      <div style={{
        padding: 14, borderRadius: radius,
        background: '#fff', border: `1px solid ${FT.line}`,
        borderLeft: `3px solid ${c}`,
        display: 'flex', gap: 12,
      }}>
        <div style={{
          width: 38, height: 38, borderRadius: 10, flexShrink: 0,
          background: statusSoft(a.status), color: c,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>{InvIcon.alert(c)}</div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', gap: 8, alignItems: 'baseline' }}>
            <div style={{ fontSize: 13, fontWeight: 700, color: navy }}>{a.tank}</div>
            <div style={{ fontSize: 13, fontWeight: 800, color: c }}>{a.level}%</div>
          </div>
          <div style={{ fontSize: 11, color: FT.inkMid, marginTop: 3, display: 'flex', alignItems: 'center', gap: 5 }}>
            {InvIcon.pin(FT.inkMid)} {a.location}
          </div>
          <div style={{
            marginTop: 8,
            display: 'flex', justifyContent: 'space-between', alignItems: 'center',
            gap: 8,
          }}>
            <div style={{ display: 'flex', gap: 8, alignItems: 'center' }}>
              <StatusPill status={a.status}/>
              <span style={{
                fontSize: 10.5, color: FT.inkSoft, fontWeight: 600,
                display: 'inline-flex', alignItems: 'center', gap: 4,
              }}>
                {InvIcon.clock(FT.inkSoft)} {a.eta}
              </span>
            </div>
            <button style={{
              padding: '5px 10px', borderRadius: 999,
              background: navy, color: '#fff', border: 'none',
              fontFamily: 'inherit', fontSize: 11, fontWeight: 700,
              cursor: 'pointer',
            }}>Restock</button>
          </div>
          <div style={{ fontSize: 10, color: FT.inkSoft, marginTop: 6, fontWeight: 500 }}>
            {a.time}
          </div>
        </div>
      </div>
    );
  };

  return (
    <InvShell
      title="Alerts"
      subtitle={`${ALERTS.length} active · ${crit.length} critical`}
      back
      activeTab="alerts"
      right={
        <button style={{
          width: 40, height: 40, borderRadius: 12,
          background: FT.card, border: 'none',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          cursor: 'pointer', color: navy,
        }}>{InvIcon.filter(navy)}</button>
      }
    >
      {/* Critical banner */}
      <div style={{
        padding: '12px 14px', borderRadius: radius,
        background: FT_STATUS.critSoft,
        border: `1px solid ${FT_STATUS.crit}33`,
        display: 'flex', alignItems: 'center', gap: 12,
        marginBottom: 16,
      }}>
        <div style={{
          width: 36, height: 36, borderRadius: 10,
          background: FT_STATUS.crit, color: '#fff',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          flexShrink: 0,
        }}>{InvIcon.alert('#fff')}</div>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 13, fontWeight: 700, color: FT_STATUS.crit }}>
            {crit.length} tanks below 20% capacity
          </div>
          <div style={{ fontSize: 11, color: FT.inkMid, marginTop: 1 }}>
            Immediate restock recommended
          </div>
        </div>
      </div>

      {/* Critical group */}
      {crit.length > 0 && (
        <>
          <div style={{
            display: 'flex', alignItems: 'center', gap: 8,
            marginBottom: 8,
          }}>
            <div style={{ width: 6, height: 6, borderRadius: 999, background: FT_STATUS.crit }}/>
            <div style={{
              fontSize: 11, fontWeight: 700, color: FT_STATUS.crit,
              letterSpacing: 0.6, textTransform: 'uppercase',
            }}>Critical</div>
            <div style={{ flex: 1, height: 1, background: FT.line }}/>
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8, marginBottom: 16 }}>
            {crit.map(a => <AlertRow key={a.id} a={a}/>)}
          </div>
        </>
      )}

      {/* Warning group */}
      {warn.length > 0 && (
        <>
          <div style={{
            display: 'flex', alignItems: 'center', gap: 8,
            marginBottom: 8,
          }}>
            <div style={{ width: 6, height: 6, borderRadius: 999, background: FT_STATUS.warn }}/>
            <div style={{
              fontSize: 11, fontWeight: 700, color: FT_STATUS.warn,
              letterSpacing: 0.6, textTransform: 'uppercase',
            }}>Warning</div>
            <div style={{ flex: 1, height: 1, background: FT.line }}/>
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            {warn.map(a => <AlertRow key={a.id} a={a}/>)}
          </div>
        </>
      )}
    </InvShell>
  );
}

// ═══ 4. RESTOCK REQUEST FORM ═══════════════════════════════
function RestockScreen() {
  const { navy, blue, radius } = getFT();
  const tank = TANKS[0];
  const [priority, setPriority] = React.useState('urgent');
  const [qty, setQty] = React.useState(9000);

  const PriorityChip = ({ id, label, sub, color }) => {
    const active = priority === id;
    return (
      <button onClick={() => setPriority(id)} style={{
        flex: 1, cursor: 'pointer', textAlign: 'left',
        padding: 12, borderRadius: radius,
        background: active ? statusSoft(color === FT_STATUS.crit ? 'crit' : color === FT_STATUS.warn ? 'warn' : 'ok') : FT.card,
        border: `1.5px solid ${active ? color : 'transparent'}`,
        fontFamily: 'inherit', position: 'relative',
      }}>
        <div style={{
          fontSize: 12, fontWeight: 700,
          color: active ? color : navy,
        }}>{label}</div>
        <div style={{ fontSize: 10.5, color: FT.inkMid, marginTop: 2 }}>{sub}</div>
        {active && (
          <div style={{
            position: 'absolute', top: 8, right: 8,
            width: 14, height: 14, borderRadius: 999, background: color,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>{Icon.check('#fff')}</div>
        )}
      </button>
    );
  };

  return (
    <InvShell
      title="Restock Request"
      subtitle="Order fuel replenishment"
      back
      activeTab="inventory"
      hasBottomNav={false}
    >
      {/* Selected tank card (context) */}
      <div style={{
        padding: 14, borderRadius: radius,
        background: FT.card, marginBottom: 18,
        display: 'flex', alignItems: 'center', gap: 12,
      }}>
        <div style={{
          width: 44, height: 44, borderRadius: 12,
          background: statusSoft('crit'), color: FT_STATUS.crit,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>{InvIcon.tank(FT_STATUS.crit)}</div>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontSize: 10.5, color: FT.inkMid, fontWeight: 600, letterSpacing: 0.4, textTransform: 'uppercase' }}>
            Target tank
          </div>
          <div style={{ fontSize: 14, fontWeight: 700, color: navy, marginTop: 1 }}>
            {tank.name}
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 6 }}>
            <StatusPill status="crit"/>
            <span style={{ fontSize: 11, color: FT.inkMid, fontWeight: 600 }}>
              {tank.current.toLocaleString()} / {tank.capacity.toLocaleString()} {tank.unit}
            </span>
          </div>
        </div>
      </div>

      {/* Priority */}
      <div style={{ marginBottom: 18 }}>
        <div style={{
          fontSize: 11, fontWeight: 700, color: FT.inkMid, letterSpacing: 0.5,
          textTransform: 'uppercase', marginBottom: 8,
        }}>Priority</div>
        <div style={{ display: 'flex', gap: 8 }}>
          <PriorityChip id="urgent"   label="Urgent"   sub="ETA < 4h" color={FT_STATUS.crit}/>
          <PriorityChip id="standard" label="Standard" sub="ETA 24h"  color={FT_STATUS.warn}/>
          <PriorityChip id="planned"  label="Planned"  sub="3–5 days" color={FT_STATUS.ok}/>
        </div>
      </div>

      {/* Quantity */}
      <div style={{ marginBottom: 18 }}>
        <div style={{
          display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
          marginBottom: 8,
        }}>
          <div style={{
            fontSize: 11, fontWeight: 700, color: FT.inkMid, letterSpacing: 0.5,
            textTransform: 'uppercase',
          }}>Quantity</div>
          <div style={{ fontSize: 10.5, color: FT.inkSoft, fontWeight: 600 }}>
            max {(tank.capacity - tank.current).toLocaleString()} {tank.unit}
          </div>
        </div>
        <div style={{
          padding: 16, borderRadius: radius,
          background: FT.card,
          display: 'flex', flexDirection: 'column', gap: 10,
        }}>
          <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'center', gap: 6 }}>
            <input type="text" value={qty.toLocaleString()} readOnly
              style={{
                border: 'none', outline: 'none', background: 'transparent',
                fontSize: 34, fontWeight: 800, color: navy, letterSpacing: -1,
                textAlign: 'right', width: 130, fontFamily: 'inherit',
              }}/>
            <span style={{ fontSize: 16, color: FT.inkSoft, fontWeight: 600 }}>L</span>
          </div>
          {/* Quick picks */}
          <div style={{ display: 'flex', gap: 6, justifyContent: 'center', flexWrap: 'wrap' }}>
            {[3000, 6000, 9000, 'Full'].map(v => (
              <button key={v} onClick={() => setQty(v === 'Full' ? tank.capacity - tank.current : v)}
                style={{
                  padding: '5px 11px', borderRadius: 999,
                  background: '#fff', border: `1px solid ${FT.line}`,
                  color: navy, fontFamily: 'inherit', fontSize: 11.5, fontWeight: 600,
                  cursor: 'pointer',
                }}>{v === 'Full' ? 'Fill up' : `${v.toLocaleString()} L`}</button>
            ))}
          </div>
        </div>
      </div>

      {/* Supplier & date */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 12, marginBottom: 18 }}>
        <TextField label="Preferred supplier" icon={InvIcon.fuel}
          placeholder="Auto-assign (best match)" value="Global Fuel Corp"/>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          <TextField label="Delivery date" icon={InvIcon.cal}
            placeholder="Today" value="Today"/>
          <TextField label="Window" icon={InvIcon.clock}
            placeholder="ASAP" value="14:00 – 17:00"/>
        </div>
        <TextField label="Notes for driver" icon={InvIcon.send}
          placeholder="Gate B, ask for shift supervisor"/>
      </div>

      {/* Cost summary */}
      <div style={{
        padding: 14, borderRadius: radius,
        background: FT.blueSoft,
        border: `1px solid ${blue}22`,
        marginBottom: 18,
      }}>
        <div style={{
          fontSize: 10.5, fontWeight: 700, color: blue,
          letterSpacing: 0.6, textTransform: 'uppercase', marginBottom: 8,
        }}>Order summary</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 5, fontSize: 12.5 }}>
          <Row label="Fuel (9,000 L × $1.28)" value="$11,520.00"/>
          <Row label="Urgent delivery" value="+ $340.00"/>
          <Row label="Taxes" value="$1,884.16"/>
          <div style={{ height: 1, background: `${blue}22`, margin: '6px 0' }}/>
          <div style={{
            display: 'flex', justifyContent: 'space-between',
            fontSize: 15, fontWeight: 800, color: navy,
          }}>
            <span>Estimated total</span>
            <span>$13,744.16</span>
          </div>
        </div>
      </div>

      <PrimaryButton trailing={Icon.arrow('#fff')}>Submit Request</PrimaryButton>
      <div style={{
        textAlign: 'center', fontSize: 11, color: FT.inkSoft, marginTop: 10,
        display: 'inline-flex', gap: 5, alignItems: 'center', justifyContent: 'center',
        width: '100%',
      }}>
        {Icon.shield(FT.inkSoft)}
        <span>Encrypted transmission · SLA-guaranteed</span>
      </div>
    </InvShell>
  );
}

function Row({ label, value }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', color: FT.inkMid }}>
      <span>{label}</span><span style={{ color: FT.navy, fontWeight: 600 }}>{value}</span>
    </div>
  );
}

Object.assign(window, {
  InventoryListScreen, TankDetailScreen, AlertsScreen, RestockScreen, TANKS, ALERTS,
});
