// FullTank auth screens v3 — spec-locked
// White bgs, navy #1A202C ink, gradient pill CTAs, light-grey inputs

// ═══ 0. SPLASH — full-bleed photo, centered logo ═══════════
function SplashScreen() {
  const { navy, ctaFrom, ctaTo } = getFT();
  return (
    <div style={{
      minHeight: '100%', width: '100%', position: 'relative',
      fontFamily: `'${getFT().font}', system-ui, sans-serif`,
      overflow: 'hidden', background: '#0F1729',
    }}>
      {/* Full-bleed photo */}
      <img src="assets/hero-highway.jpg" alt=""
        style={{
          position: 'absolute', inset: 0, width: '100%', height: '100%',
          objectFit: 'cover',
        }}/>
      {/* Dark blue gradient overlay */}
      <div style={{
        position: 'absolute', inset: 0,
        background: `linear-gradient(180deg, ${navy}dd 0%, ${navy}aa 40%, ${navy}f0 100%)`,
      }}/>

      {/* Status bar spacer */}
      <div style={{ position: 'relative', zIndex: 2, height: 54 }}/>

      {/* Center content */}
      <div style={{
        position: 'relative', zIndex: 2,
        minHeight: 'calc(100% - 54px)',
        display: 'flex', flexDirection: 'column',
        alignItems: 'center', justifyContent: 'space-between',
        padding: '40px 32px 40px',
        boxSizing: 'border-box',
      }}>
        {/* Spacer */}
        <div/>

        {/* Center block */}
        <div style={{
          display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 28,
          textAlign: 'center', maxWidth: 300,
        }}>
          {/* Logo (inverted white variant) */}
          <img src="assets/fulltank-logo.png" alt="FullTank"
            style={{
              height: 62, width: 'auto', display: 'block',
              filter: 'brightness(0) invert(1) drop-shadow(0 8px 24px rgba(0,0,0,0.4))',
            }}/>

          <div>
            <h1 style={{
              margin: 0, fontSize: 26, fontWeight: 700, letterSpacing: -0.5,
              color: '#fff', lineHeight: 1.25,
            }}>Guaranteed fuel<br/>for your operation</h1>
            <p style={{
              margin: '12px 0 0', fontSize: 14, color: 'rgba(255,255,255,0.75)',
              lineHeight: 1.55, fontWeight: 500,
            }}>
              B2B fuel supply chain, digitized.
            </p>
          </div>

          {/* Loader */}
          <div style={{
            marginTop: 6,
            width: 38, height: 38, borderRadius: 999,
            border: `3px solid rgba(255,255,255,0.15)`,
            borderTopColor: ctaFrom,
            animation: 'ftspin 0.9s linear infinite',
          }}/>
          <style>{`@keyframes ftspin { to { transform: rotate(360deg); } }`}</style>
        </div>

        {/* Footer */}
        <div style={{
          display: 'inline-flex', alignItems: 'center', gap: 8,
          fontSize: 11, color: 'rgba(255,255,255,0.55)', letterSpacing: 0.6,
          fontWeight: 500,
        }}>
          {Icon.shield('rgba(255,255,255,0.55)')}
          <span>SOC 2 · ISO 27001 · v2.4.1</span>
        </div>
      </div>
    </div>
  );
}

// ═══ 1. LOGIN ══════════════════════════════════════════════
function LoginScreen() {
  const { navy, blue } = getFT();
  return (
    <div style={{
      minHeight: '100%', background: '#fff',
      fontFamily: `'${getFT().font}', system-ui, sans-serif`,
      color: navy,
    }}>
      {/* Header with cropped truck photo */}
      <div style={{
        height: 200, position: 'relative', overflow: 'hidden',
      }}>
        <img src="assets/hero-truck.jpg" alt=""
          style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', objectFit: 'cover' }}/>
        <div style={{
          position: 'absolute', inset: 0,
          background: `linear-gradient(180deg, ${navy}55 0%, ${navy}aa 70%, #fff 100%)`,
        }}/>
        <div style={{ height: 54 }}/>
        <div style={{
          position: 'relative', zIndex: 2, padding: '14px 24px 0',
          display: 'flex', justifyContent: 'space-between', alignItems: 'center',
        }}>
          <FTLogo height={26} invert/>
          <div style={{
            padding: '5px 11px', border: '1px solid rgba(255,255,255,0.35)',
            borderRadius: 999, fontSize: 10.5, fontWeight: 700, letterSpacing: 0.8,
            color: '#fff', background: 'rgba(255,255,255,0.12)',
            backdropFilter: 'blur(10px)',
          }}>B2B · v2.4</div>
        </div>
      </div>

      {/* Content */}
      <div style={{ padding: '4px 24px 32px', marginTop: -8, position: 'relative', zIndex: 3 }}>
        <div style={{ marginBottom: 22 }}>
          <h1 style={{
            margin: 0, fontSize: 28, fontWeight: 700, letterSpacing: -0.7, color: navy,
          }}>Welcome back</h1>
          <p style={{ margin: '6px 0 0', fontSize: 13.5, color: FT.inkMid, lineHeight: 1.5 }}>
            Sign in to manage your supply operations in real time.
          </p>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          <TextField label="Corporate Email" icon={Icon.mail}
            placeholder="example@mycompany.com" type="email" />
          <TextField label="Password" icon={Icon.lock}
            placeholder="••••••••" type="password"
            trailing={<span style={{ color: FT.inkSoft, cursor: 'pointer', display: 'flex' }}>{Icon.eye(FT.inkSoft)}</span>}
          />

          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 2 }}>
            <Checkbox checked={true} small>Remember me</Checkbox>
            <a style={{
              fontSize: 13, fontWeight: 600, color: blue,
              textDecoration: 'none', cursor: 'pointer',
            }}>Forgot password?</a>
          </div>

          <div style={{ marginTop: 10 }}>
            <PrimaryButton trailing={Icon.arrow('#fff')}>Sign In</PrimaryButton>
          </div>

          <div style={{ display: 'flex', alignItems: 'center', gap: 12, margin: '12px 0 4px' }}>
            <div style={{ flex: 1, height: 1, background: FT.line }}/>
            <span style={{ fontSize: 10.5, color: FT.inkSoft, letterSpacing: 1, fontWeight: 600 }}>NEW TO FULLTANK</span>
            <div style={{ flex: 1, height: 1, background: FT.line }}/>
          </div>

          <SecondaryButton>Create business account</SecondaryButton>

          <div style={{
            textAlign: 'center', fontSize: 11, color: FT.inkSoft, marginTop: 10,
            display: 'inline-flex', gap: 6, justifyContent: 'center', alignItems: 'center',
            width: '100%', letterSpacing: 0.3,
          }}>
            {Icon.shield(FT.inkSoft)}
            <span>End-to-end encrypted · SOC 2 Type II</span>
          </div>
        </div>
      </div>
    </div>
  );
}

// ═══ 2. SIGNUP — Step 1 of 2 ═══════════════════════════════
function SignupScreen() {
  const { navy, blue, radius } = getFT();
  const [role, setRole] = React.useState('supplier');

  const RoleCard = ({ id, icon, title, subtitle }) => {
    const active = role === id;
    return (
      <button onClick={() => setRole(id)} style={{
        flex: 1, cursor: 'pointer', textAlign: 'left',
        padding: '14px 12px',
        background: active ? FT.blueSoft : FT.card,
        border: `1.5px solid ${active ? blue : 'transparent'}`,
        borderRadius: radius,
        display: 'flex', flexDirection: 'column', gap: 10,
        position: 'relative',
        transition: 'all .15s',
      }}>
        <div style={{
          width: 40, height: 40, borderRadius: 10,
          background: active
            ? `linear-gradient(135deg, ${FT.ctaFrom} 0%, ${FT.ctaTo} 100%)`
            : '#fff',
          color: active ? '#fff' : FT.inkMid,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: active ? `0 6px 14px -6px ${FT.ctaTo}aa` : 'none',
        }}>
          {icon(active ? '#fff' : FT.inkMid)}
        </div>
        <div>
          <div style={{
            fontSize: 13, fontWeight: 700, lineHeight: 1.2,
            color: active ? blue : navy,
          }}>{title}</div>
          <div style={{
            fontSize: 11, marginTop: 3, lineHeight: 1.35,
            color: FT.inkMid,
          }}>{subtitle}</div>
        </div>
        {active && (
          <div style={{
            position: 'absolute', top: 10, right: 10,
            width: 18, height: 18, borderRadius: 999, background: blue,
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>{Icon.check('#fff')}</div>
        )}
      </button>
    );
  };

  return (
    <div style={{
      minHeight: '100%', background: '#fff',
      fontFamily: `'${getFT().font}', system-ui, sans-serif`,
      color: navy,
    }}>
      <div style={{ height: 54 }}/>
      <div style={{ padding: '8px 24px 32px' }}>
        {/* Header: back + logo */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: 22 }}>
          <BackButton/>
          <FTLogo height={22}/>
        </div>

        {/* Progress + Title */}
        <div style={{ marginBottom: 20 }}>
          <div style={{
            display: 'inline-flex', alignItems: 'center', gap: 8,
            marginBottom: 8,
          }}>
            <div style={{
              padding: '3px 9px', borderRadius: 999,
              background: FT.blueSoft, color: blue,
              fontSize: 10.5, fontWeight: 700, letterSpacing: 0.8,
            }}>STEP 1 OF 2</div>
            {/* Step dots */}
            <div style={{ display: 'flex', gap: 4 }}>
              <div style={{ width: 18, height: 3, borderRadius: 2, background: blue }}/>
              <div style={{ width: 18, height: 3, borderRadius: 2, background: FT.line }}/>
            </div>
          </div>
          <h1 style={{ margin: 0, fontSize: 26, fontWeight: 700, letterSpacing: -0.6, color: navy }}>
            Create your account
          </h1>
          <p style={{ margin: '6px 0 0', fontSize: 13, color: FT.inkMid, lineHeight: 1.5 }}>
            Select your role in the supply chain to configure your dashboard.
          </p>
        </div>

        {/* Role selector */}
        <div style={{ marginBottom: 20 }}>
          <div style={{
            fontSize: 11, fontWeight: 600, color: FT.inkMid, marginBottom: 8,
            letterSpacing: 0.4, textTransform: 'uppercase',
          }}>Your role</div>
          <div style={{ display: 'flex', gap: 10 }}>
            <RoleCard id="supplier" icon={Icon.truck}
              title="Fuel Supplier" subtitle="I distribute and deliver fuel"/>
            <RoleCard id="requester" icon={Icon.chart}
              title="Requesting Company" subtitle="I purchase fuel to operate"/>
          </div>
        </div>

        {/* Form */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          <TextField label="Full Name" icon={Icon.user}
            placeholder="Samuel Ruiz" />
          <TextField label="Company Name" icon={Icon.building}
            placeholder="Northern Fuels Inc." />
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
            <TextField label="Tax ID" icon={Icon.id}
              placeholder="XAXX010101" />
            <TextField label="Phone" icon={Icon.phone}
              placeholder="+1 555 ..." type="tel"/>
          </div>
          <TextField label="Corporate Email" icon={Icon.mail}
            placeholder="samuel@company.com" type="email" />

          <div style={{ marginTop: 16 }}>
            <PrimaryButton trailing={Icon.arrow('#fff')}>Continue</PrimaryButton>
          </div>

          <div style={{
            textAlign: 'center', fontSize: 13, color: FT.inkMid, marginTop: 6,
          }}>
            Already have an account? <span style={{ color: blue, fontWeight: 600 }}>Sign in</span>
          </div>
        </div>
      </div>
    </div>
  );
}

// ═══ 3. RECOVER PASSWORD ═══════════════════════════════════
function RecoverScreen() {
  const { navy, blue, radius } = getFT();
  return (
    <div style={{
      minHeight: '100%', background: '#fff',
      fontFamily: `'${getFT().font}', system-ui, sans-serif`,
      color: navy,
    }}>
      {/* Header with storage-tank photo */}
      <div style={{
        height: 190, position: 'relative', overflow: 'hidden',
      }}>
        <img src="assets/hero-tanks.jpg" alt=""
          style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', objectFit: 'cover' }}/>
        <div style={{
          position: 'absolute', inset: 0,
          background: `linear-gradient(180deg, ${navy}55 0%, ${navy}aa 70%, #fff 100%)`,
        }}/>
        <div style={{ height: 54 }}/>
        <div style={{
          position: 'relative', zIndex: 2, padding: '14px 24px 0',
          display: 'flex', alignItems: 'center', gap: 14,
        }}>
          <BackButton onDark/>
          <FTLogo height={22} invert/>
        </div>
      </div>

      {/* Content */}
      <div style={{ padding: '4px 24px 32px', position: 'relative', zIndex: 3 }}>
        <div style={{ marginBottom: 22 }}>
          <div style={{
            display: 'inline-block',
            padding: '4px 10px', borderRadius: 999,
            background: FT.blueSoft, color: blue,
            fontSize: 10.5, fontWeight: 700, letterSpacing: 0.8,
            marginBottom: 10,
          }}>SECURE RECOVERY</div>
          <h1 style={{
            margin: 0, fontSize: 28, fontWeight: 700, letterSpacing: -0.7, color: navy,
          }}>Recover Password</h1>
          <p style={{ margin: '8px 0 0', fontSize: 13.5, color: FT.inkMid, lineHeight: 1.55 }}>
            Enter your corporate email to receive the access code.
          </p>
        </div>

        <div style={{ display: 'flex', flexDirection: 'column', gap: 14 }}>
          <TextField label="Corporate Email" icon={Icon.mail}
            placeholder="example@mycompany.com" type="email" />

          {/* Light-blue info box */}
          <div style={{
            display: 'flex', gap: 12, padding: 14,
            background: FT.info,
            border: `1px solid ${FT.infoBorder}`,
            borderRadius: radius,
          }}>
            <div style={{
              flexShrink: 0, color: FT.infoInk, display: 'flex',
              marginTop: 1,
            }}>{Icon.info(FT.infoInk)}</div>
            <div>
              <div style={{ fontSize: 12.5, fontWeight: 700, color: FT.infoInk, marginBottom: 3 }}>
                Check your inbox
              </div>
              <div style={{ fontSize: 12, color: FT.navyMid, lineHeight: 1.5 }}>
                The code expires in <b>15 minutes</b>. If it doesn't appear, check your spam folder.
              </div>
            </div>
          </div>

          <div style={{ marginTop: 8 }}>
            <PrimaryButton trailing={Icon.arrow('#fff')}>Send Code</PrimaryButton>
          </div>

          <button style={{
            width: '100%', height: 44, cursor: 'pointer',
            background: 'transparent', color: blue,
            border: 'none', fontFamily: 'inherit', fontSize: 13, fontWeight: 600,
          }}>
            ← Return to login
          </button>

          {/* Support */}
          <div style={{
            marginTop: 4, padding: '14px 16px',
            background: FT.card, borderRadius: radius,
            display: 'flex', justifyContent: 'space-between', alignItems: 'center',
            gap: 12,
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
              <div style={{
                width: 36, height: 36, borderRadius: 8,
                background: '#fff',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                color: navy,
              }}>{Icon.help(navy)}</div>
              <div>
                <div style={{ fontSize: 11, color: FT.inkMid, lineHeight: 1.2 }}>Need help?</div>
                <div style={{ fontSize: 13, fontWeight: 700, color: navy, marginTop: 1 }}>
                  Contact 24/7 support
                </div>
              </div>
            </div>
            <div style={{ color: navy, display: 'flex' }}>{Icon.arrow(navy)}</div>
          </div>
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { SplashScreen, LoginScreen, SignupScreen, RecoverScreen });
