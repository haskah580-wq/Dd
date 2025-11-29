<!doctype html>
<html lang="id">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Pokeventur Store</title>
  <meta name="description" content="Toko resmi Pokeventur — merchandise Pokémon, plushie, aksesori, dan banyak lagi." />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
  <style>
    :root{
      --bg:#0f1724; /* dark navy */
      --card:#0b1220;
      --accent:#ffcc00; /* pokémon-ish accent */
      --muted:#94a3b8;
      --glass: rgba(255,255,255,0.04);
      --radius:12px;
      font-family: 'Inter', system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial;
    }
    *{box-sizing:border-box}
    html,body{height:100%}
    body{
      margin:0;
      background:linear-gradient(180deg,#071022 0%, #081428 60%);
      color:#e6eef8;
      -webkit-font-smoothing:antialiased;
      -moz-osx-font-smoothing:grayscale;
      padding:24px;
    }

    header{
      display:flex;align-items:center;gap:18px;justify-content:space-between;margin-bottom:20px;
    }
    .brand{display:flex;gap:12px;align-items:center}
    .logo{
      width:54px;height:54px;border-radius:12px;background:linear-gradient(135deg,var(--accent),#ff7a00);display:flex;align-items:center;justify-content:center;color:#071022;font-weight:700;font-size:20px;box-shadow:0 6px 18px rgba(255,140,0,0.08)
    }
    .brand h1{margin:0;font-size:20px}
    .brand p{margin:0;font-size:12px;color:var(--muted)}

    .controls{display:flex;gap:12px;align-items:center}
    .search{background:var(--glass);padding:8px 12px;border-radius:999px;border:1px solid rgba(255,255,255,0.03);display:flex;gap:8px;align-items:center}
    .search input{background:transparent;border:0;outline:0;color:inherit;width:220px}
    .btn{background:linear-gradient(90deg,var(--accent),#ff7a00);color:#071022;padding:8px 12px;border-radius:10px;border:0;cursor:pointer;font-weight:600}
    .icon-btn{background:transparent;border:1px solid rgba(255,255,255,0.03);padding:8px;border-radius:10px;cursor:pointer}

    main{display:grid;grid-template-columns:1fr 340px;gap:20px}

    /* products */
    .grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:14px}
    .card{background:linear-gradient(180deg,rgba(255,255,255,0.02),transparent);padding:14px;border-radius:12px;border:1px solid rgba(255,255,255,0.03);display:flex;flex-direction:column;gap:10px}
    .card img{width:100%;height:140px;object-fit:cover;border-radius:10px;background:#071122}
    .card h3{margin:0;font-size:16px}
    .price{font-weight:700;color:var(--accent)}
    .meta{display:flex;justify-content:space-between;align-items:center}
    .small{font-size:13px;color:var(--muted)}

    /* cart */
    .cart{background:linear-gradient(180deg,rgba(255,255,255,0.02),transparent);padding:14px;border-radius:12px;border:1px solid rgba(255,255,255,0.03);min-height:200px}
    .cart h2{margin:0 0 8px 0}
    .cart-list{display:flex;flex-direction:column;gap:8px;max-height:440px;overflow:auto;padding-right:6px}
    .cart-item{display:flex;gap:10px;align-items:center}
    .cart-item img{width:56px;height:56px;border-radius:8px;object-fit:cover}
    .qty{display:inline-flex;align-items:center;gap:6px}
    .qty button{background:transparent;border:1px solid rgba(255,255,255,0.03);padding:4px 8px;border-radius:8px;color:inherit;cursor:pointer}

    footer{margin-top:22px;color:var(--muted);font-size:13px;text-align:center}

    /* responsive */
    @media (max-width:920px){
      main{grid-template-columns:1fr}
      .controls .search input{width:120px}
    }

    /* product badges */
    .badge{background:rgba(255,255,255,0.04);padding:4px 8px;border-radius:999px;font-size:12px;color:var(--muted)}

    /* empty state */
    .empty{padding:22px;border-radius:10px;background:linear-gradient(90deg,rgba(255,255,255,0.01),transparent);text-align:center}
  </style>
</head>
<body>
  <header>
    <div class="brand">
      <div class="logo">PV</div>
      <div>
        <h1>Pokeventur Store</h1>
        <p>Merch, plushie, aksesori, &amp; item collector</p>
      </div>
    </div>

    <div class="controls">
      <div class="search" role="search">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" aria-hidden><path d="M21 21l-4.35-4.35" stroke="#fff" stroke-opacity="0.6" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"></path><circle cx="11" cy="11" r="6" stroke="#fff" stroke-opacity="0.6" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"></circle></svg>
        <input id="q" placeholder="Cari produk... (mis. plushie)" />
      </div>
      <button class="btn" id="checkoutBtn">Checkout</button>
      <button class="icon-btn" id="clearBtn" title="Kosongkan keranjang">🧹</button>
    </div>
  </header>

  <main>
    <section>
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px">
        <div style="display:flex;gap:10px;align-items:center">
          <div class="badge">Gratis ongkir > Rp200.000</div>
          <div class="small">Kirim cepat: 1-3 hari kerja</div>
        </div>
        <div class="small">Total produk: <span id="productCount">0</span></div>
      </div>

      <div class="grid" id="products"></div>

    </section>

    <aside class="cart">
      <h2>Keranjang <small id="cartCount" style="color:var(--muted)">0 item</small></h2>
      <div class="cart-list" id="cartList">
        <div class="empty" id="cartEmpty">Keranjang kosong — tambahkan produk dari sebelah kiri.</div>
      </div>
      <div style="margin-top:12px;display:flex;justify-content:space-between;align-items:center">
        <div>
          <div class="small">Subtotal</div>
          <div style="font-weight:700;font-size:18px" id="subtotal">Rp0</div>
        </div>
        <div>
          <button class="btn" id="buyNow">Bayar Sekarang</button>
        </div>
      </div>
    </aside>
  </main>

  <footer>
    © <span id="year"></span> Pokeventur — Semua hak cipta dilindungi.
  </footer>

  <script>
    // --- Simple product data (replace or extend) ---
    const PRODUCTS = [
      {id:'p001',name:'Legendary Pokémon',price:150000,img:'https://images.unsplash.com/photo-1601758123927-7b2d0b69e3a7?auto=format&fit=crop&w=800&q=60',tag:'Legendary'},
      {id:'p002',name:'Rare Candy',price:5000,img:'https://images.unsplash.com/photo-1585386959984-a4155225b6b5?auto=format&fit=crop&w=800&q=60',tag:'Item'},
      {id:'p003',name:'Battle Badge',price:10000,img:'https://images.unsplash.com/photo-1520975916558-1c7d7efb1b3b?auto=format&fit=crop&w=800&q=60',tag:'Badge'},
      {id:'p004',name:'Addon SERP Pokédrock',price:10000,img:'https://images.unsplash.com/photo-1526318472351-c75fcf070c9f?auto=format&fit=crop&w=800&q=60',tag:'Addon'},
      {id:'p005',name:'Desain Pokémon',price:10000,img:'https://images.unsplash.com/photo-1544211413-0c9e9d0fb8b2?auto=format&fit=crop&w=800&q=60',tag:'Design'}
    ];

    // --- Utility helpers ---
    const fmt = (n)=> 'Rp' + n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, '.');

    // --- Render products ---
    const productsEl = document.getElementById('products');
    const productCountEl = document.getElementById('productCount');
    const qInput = document.getElementById('q');

    function renderProducts(filter=''){
      productsEl.innerHTML='';
      const filtered = PRODUCTS.filter(p=> p.name.toLowerCase().includes(filter.toLowerCase()) || p.tag.toLowerCase().includes(filter.toLowerCase()));
      productCountEl.textContent = filtered.length;
      if(filtered.length===0){
        productsEl.innerHTML = '<div class="empty">Produk tidak ditemukan.</div>';
        return;
      }
      for(const p of filtered){
        const card = document.createElement('article');
        card.className='card';
        card.innerHTML = `
          <img src="${p.img}" alt="${p.name}" loading="lazy" />
          <div style="display:flex;justify-content:space-between;align-items:center">
            <h3>${p.name}</h3>
            <div class="badge">${p.tag}</div>
          </div>
          <div class="meta">
            <div class="small">Stok: 99</div>
            <div class="price">${fmt(p.price)}</div>
          </div>
          <div style="display:flex;gap:8px">
            <button class="btn addBtn" data-id="${p.id}">Tambah</button>
            <button class="icon-btn" data-id="${p.id}" title="Lihat detail">ℹ️</button>
          </div>
        `;
        productsEl.appendChild(card);
      }
      attachAddHandlers();
    }

    // --- Cart ---
    let CART = JSON.parse(localStorage.getItem('pv_cart')||'{}');

    function saveCart(){ localStorage.setItem('pv_cart', JSON.stringify(CART)); }

    function addToCart(id, qty=1){
      const prod = PRODUCTS.find(p=>p.id===id);
      if(!prod) return;
      if(CART[id]) CART[id].qty += qty; else CART[id]={...prod, qty};
      saveCart(); renderCart();
    }

    function removeFromCart(id){ delete CART[id]; saveCart(); renderCart(); }

    function changeQty(id, delta){ if(!CART[id]) return; CART[id].qty += delta; if(CART[id].qty<=0) delete CART[id]; saveCart(); renderCart(); }

    const cartList = document.getElementById('cartList');
    const cartCountEl = document.getElementById('cartCount');
    const subtotalEl = document.getElementById('subtotal');

    function renderCart(){
      const ids = Object.keys(CART);
      cartList.innerHTML='';
      if(ids.length===0){ cartList.appendChild(document.getElementById('cartEmpty')); cartCountEl.textContent='0 item'; subtotalEl.textContent = fmt(0); return; }
      cartCountEl.textContent = ids.reduce((s,id)=>s + CART[id].qty,0) + ' item';
      let total = 0;
      for(const id of ids){
        const item = CART[id];
        total += item.price * item.qty;
        const div = document.createElement('div'); div.className='cart-item';
        div.innerHTML = `
          <img src="${item.img}" alt="${item.name}" />
          <div style="flex:1">
            <div style="display:flex;justify-content:space-between;align-items:center">
              <div style="font-weight:600">${item.name}</div>
              <div style="font-weight:700">${fmt(item.price * item.qty)}</div>
            </div>
            <div style="display:flex;justify-content:space-between;align-items:center;margin-top:6px">
              <div class="small">${item.tag}</div>
              <div class="qty">
                <button data-action="dec" data-id="${id}">-</button>
                <div style="min-width:26px;text-align:center">${item.qty}</div>
                <button data-action="inc" data-id="${id}">+</button>
                <button style="margin-left:8px" data-action="rem" data-id="${id}">🗑</button>
              </div>
            </div>
          </div>
        `;
        cartList.appendChild(div);
      }
      subtotalEl.textContent = fmt(total);

      // attach cart handlers
      cartList.querySelectorAll('button').forEach(btn=>{
        btn.addEventListener('click',()=>{
          const id = btn.dataset.id; const action = btn.dataset.action;
          if(action==='dec') changeQty(id,-1);
          if(action==='inc') changeQty(id,1);
          if(action==='rem') removeFromCart(id);
        });
      });
    }

    // attach add handlers
    function attachAddHandlers(){ document.querySelectorAll('.addBtn').forEach(b=>{ b.addEventListener('click',()=> addToCart(b.dataset.id)); }); }

    // search
    qInput.addEventListener('input', e=> renderProducts(e.target.value));

    // clear cart
    document.getElementById('clearBtn').addEventListener('click', ()=>{ CART={}; saveCart(); renderCart(); });

    // checkout / buy
    document.getElementById('checkoutBtn').addEventListener('click', ()=>{ alert('Arahkan ke halaman checkout (contoh): total ' + subtotalEl.textContent); });
    document.getElementById('buyNow').onclick = () => {
        window.location.href = 'https://wa.me/6282181745230?text=Halo%20saya%20ingin%20melanjutkan%20pembayaran%20Pokeventur%20Store';
      }; return; }
      // Example checkout flow (mock)
      const total = subtotalEl.textContent;
      const ok = confirm('Konfirmasi pembelian — Total: ' + total + '\nLanjutkan?');
      if(ok){
        // mock success
        CART = {}; saveCart(); renderCart(); alert('Terima kasih! Pesanan Anda berhasil diproses.');
      }
    });

    // init
    document.getElementById('year').textContent = new Date().getFullYear();
    renderProducts(); renderCart();
  </script>
</body>
</html>
