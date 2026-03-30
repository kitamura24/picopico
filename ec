<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Shopify RAW層 テーブル定義 - Customer</title>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@300;400;500;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
<style>
  :root {
    --bg: #fafafa;
    --surface: #ffffff;
    --border: #e2e8f0;
    --border-light: #f1f5f9;
    --text: #1e293b;
    --text-secondary: #64748b;
    --text-muted: #94a3b8;
    --accent: #2563eb;
    --accent-light: #eff6ff;
    --record-bg: #fefce8;
    --record-border: #fde047;
    --record-text: #854d0e;
    --list-bg: #f0fdf4;
    --list-border: #86efac;
    --list-text: #166534;
    --scalar-bg: #f8fafc;
    --scalar-text: #475569;
    --required-bg: #fef2f2;
    --required-text: #dc2626;
    --nullable-bg: #f0f9ff;
    --nullable-text: #0369a1;
    --repeated-bg: #faf5ff;
    --repeated-text: #7c3aed;
    --child-indent: #e2e8f0;
    --expand-hover: #dbeafe;
    --shadow: 0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04);
    --shadow-md: 0 4px 6px rgba(0,0,0,0.05), 0 2px 4px rgba(0,0,0,0.04);
  }

  * { margin: 0; padding: 0; box-sizing: border-box; }

  body {
    font-family: 'Noto Sans JP', sans-serif;
    background: var(--bg);
    color: var(--text);
    line-height: 1.7;
    padding: 2rem;
  }

  .container { max-width: 1200px; margin: 0 auto; }

  h1 {
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 0.25rem;
    color: var(--text);
  }

  .subtitle {
    font-size: 0.85rem;
    color: var(--text-secondary);
    margin-bottom: 2rem;
  }

  .subtitle a {
    color: var(--accent);
    text-decoration: none;
  }
  .subtitle a:hover { text-decoration: underline; }

  .meta-section {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 1rem;
    margin-bottom: 2rem;
  }

  .meta-card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 8px;
    padding: 1rem 1.2rem;
    box-shadow: var(--shadow);
  }

  .meta-card dt {
    font-size: 0.7rem;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--text-muted);
    margin-bottom: 0.25rem;
  }

  .meta-card dd {
    font-size: 0.85rem;
    font-weight: 500;
    color: var(--text);
    font-family: 'JetBrains Mono', monospace;
  }

  .legend {
    display: flex;
    flex-wrap: wrap;
    gap: 0.75rem;
    margin-bottom: 1.5rem;
    font-size: 0.75rem;
  }

  .legend-item {
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
  }

  .legend-badge {
    display: inline-block;
    padding: 0.1rem 0.5rem;
    border-radius: 4px;
    font-size: 0.65rem;
    font-weight: 500;
    font-family: 'JetBrains Mono', monospace;
  }

  /* Table */
  .table-wrap {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: 10px;
    overflow: hidden;
    box-shadow: var(--shadow-md);
    margin-bottom: 2.5rem;
  }

  .table-title {
    padding: 1rem 1.5rem;
    font-size: 1rem;
    font-weight: 700;
    border-bottom: 1px solid var(--border);
    background: var(--surface);
    display: flex;
    align-items: center;
    gap: 0.5rem;
  }

  .table-title code {
    font-family: 'JetBrains Mono', monospace;
    font-size: 0.95rem;
    color: var(--accent);
  }

  table {
    width: 100%;
    border-collapse: collapse;
    font-size: 0.82rem;
  }

  thead th {
    background: #f8fafc;
    padding: 0.65rem 1rem;
    text-align: left;
    font-weight: 600;
    font-size: 0.7rem;
    text-transform: uppercase;
    letter-spacing: 0.04em;
    color: var(--text-secondary);
    border-bottom: 2px solid var(--border);
    position: sticky;
    top: 0;
    z-index: 10;
  }

  tbody tr { border-bottom: 1px solid var(--border-light); }
  tbody tr:last-child { border-bottom: none; }
  tbody tr:hover { background: #fafbfd; }

  td {
    padding: 0.55rem 1rem;
    vertical-align: top;
  }

  .col-num { width: 3.5rem; color: var(--text-muted); font-family: 'JetBrains Mono', monospace; font-size: 0.75rem; }
  .col-field { width: 22%; }
  .col-bqtype { width: 10%; }
  .col-mode { width: 9%; }
  .col-struct { width: 9%; }
  .col-desc { }

  .field-name {
    font-family: 'JetBrains Mono', monospace;
    font-weight: 500;
    font-size: 0.8rem;
    color: var(--text);
  }

  .field-name.child {
    color: var(--text-secondary);
    font-weight: 400;
  }

  .bq-type {
    font-family: 'JetBrains Mono', monospace;
    font-size: 0.75rem;
    color: var(--text-secondary);
  }

  .badge {
    display: inline-block;
    padding: 0.1rem 0.45rem;
    border-radius: 4px;
    font-size: 0.65rem;
    font-weight: 500;
    font-family: 'JetBrains Mono', monospace;
    white-space: nowrap;
  }

  .badge-required { background: var(--required-bg); color: var(--required-text); }
  .badge-nullable { background: var(--nullable-bg); color: var(--nullable-text); }
  .badge-repeated { background: var(--repeated-bg); color: var(--repeated-text); }

  .struct-badge {
    display: inline-block;
    padding: 0.1rem 0.45rem;
    border-radius: 4px;
    font-size: 0.65rem;
    font-weight: 500;
    font-family: 'JetBrains Mono', monospace;
  }

  .struct-scalar { background: var(--scalar-bg); color: var(--scalar-text); }
  .struct-record { background: var(--record-bg); color: var(--record-text); }
  .struct-list { background: var(--list-bg); color: var(--list-text); }

  .desc-text {
    font-size: 0.8rem;
    color: var(--text-secondary);
    line-height: 1.5;
  }

  .desc-text a {
    color: var(--accent);
    text-decoration: none;
    font-size: 0.72rem;
  }
  .desc-text a:hover { text-decoration: underline; }

  /* Expandable rows */
  .expandable-row {
    cursor: pointer;
    user-select: none;
    transition: background 0.15s;
  }

  .expandable-row:hover { background: var(--expand-hover) !important; }

  .expand-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 18px;
    height: 18px;
    border-radius: 4px;
    background: var(--border);
    color: var(--text-secondary);
    font-size: 0.7rem;
    margin-right: 0.4rem;
    transition: transform 0.2s, background 0.15s;
    flex-shrink: 0;
    font-family: 'JetBrains Mono', monospace;
    font-weight: 700;
  }

  .expandable-row.expanded .expand-icon {
    transform: rotate(90deg);
    background: var(--accent);
    color: white;
  }

  .child-row { display: none; }
  .child-row.visible { display: table-row; }

  .child-row td {
    background: #fcfcfe;
    border-left: 3px solid var(--child-indent);
  }

  .child-row td:first-child {
    padding-left: 2rem;
  }

  .child-row .field-name {
    padding-left: 1.2rem;
  }

  .field-name-wrap {
    display: flex;
    align-items: center;
  }

  /* Separate table section */
  .sep-table-note {
    margin-top: 2rem;
    padding: 1rem 1.5rem;
    background: #fffbeb;
    border: 1px solid #fde68a;
    border-radius: 8px;
    font-size: 0.82rem;
    color: #92400e;
    margin-bottom: 2.5rem;
  }

  .sep-table-note strong { font-weight: 600; }

  .connection-table {
    margin-top: 2rem;
  }

  .connection-table table td { font-size: 0.8rem; }
  .connection-table .badge-scope {
    background: #f1f5f9;
    color: #475569;
    padding: 0.1rem 0.45rem;
    border-radius: 4px;
    font-size: 0.65rem;
    font-family: 'JetBrains Mono', monospace;
  }

  @media (max-width: 768px) {
    body { padding: 1rem; }
    .meta-section { grid-template-columns: 1fr; }
    td, th { padding: 0.4rem 0.6rem; }
    .col-field { width: auto; }
  }
</style>
</head>
<body>
<div class="container">

<h1>Shopify RAW層 テーブル定義</h1>
<p class="subtitle">
  GraphQL Admin API 2026-01 ―
  <a href="https://shopify.dev/docs/api/admin-graphql/latest/objects/Customer" target="_blank">Customer オブジェクト</a>
</p>

<div class="meta-section">
  <dl class="meta-card">
    <dt>テーブル名</dt>
    <dd>raw_shopify_customers</dd>
  </dl>
  <dl class="meta-card">
    <dt>パーティション</dt>
    <dd>loaded_date</dd>
  </dl>
  <dl class="meta-card">
    <dt>重複排除キー</dt>
    <dd>id</dd>
  </dl>
  <dl class="meta-card">
    <dt>格納方針</dt>
    <dd>1顧客1行</dd>
  </dl>
</div>

<div class="legend">
  <span class="legend-item"><span class="badge badge-required">REQUIRED</span> 必須</span>
  <span class="legend-item"><span class="badge badge-nullable">NULLABLE</span> NULL許容</span>
  <span class="legend-item"><span class="badge badge-repeated">REPEATED</span> 配列</span>
  <span class="legend-item"><span class="struct-badge struct-scalar">スカラー</span> 単一値</span>
  <span class="legend-item"><span class="struct-badge struct-record">オブジェクト</span> ネスト構造（クリックで展開）</span>
  <span class="legend-item"><span class="struct-badge struct-list">リスト</span> 配列</span>
</div>

<!-- ==================== raw_shopify_customers ==================== -->
<div class="table-wrap">
  <div class="table-title"><code>raw_shopify_customers</code></div>
  <table>
    <thead>
      <tr>
        <th class="col-num">#</th>
        <th class="col-field">フィールド名</th>
        <th class="col-bqtype">BQ型</th>
        <th class="col-mode">モード</th>
        <th class="col-struct">構造</th>
        <th class="col-desc">説明</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td class="col-num">1</td>
        <td><span class="field-name">id</span></td>
        <td><span class="bq-type">STRING</span></td>
        <td><span class="badge badge-required">REQUIRED</span></td>
        <td><span class="struct-badge struct-scalar">スカラー</span></td>
        <td><span class="desc-text">グローバル一意の顧客ID（gid://shopify/Customer/xxx）</span></td>
      </tr>
      <tr>
        <td class="col-num">2</td>
        <td><span class="field-name">legacy_resource_id</span></td>
        <td><span class="bq-type">INT64</span></td>
        <td><span class="badge badge-required">REQUIRED</span></td>
        <td><span class="struct-badge struct-scalar">スカラー</span></td>
        <td><span class="desc-text">REST APIの対応ID</span></td>
      </tr>
      <tr>
        <td class="col-num">3</td>
        <td><span class="field-name">first_name</span></td>
        <td><span class="bq-type">STRING</span></td>
        <td><span class="badge badge-nullable">NULLABLE</span></td>
        <td><span class="struct-badge struct-scalar">スカラー</span></td>
        <td><span class="desc-text">顧客の名</span></td>
      </tr>
      <tr>
        <td class="col-num">4</td>
        <td><span class="field-name">last_name</span></td>
        <td><span class="bq-type">STRING</span></td>
        <td><span class="badge badge-nullable">NULLABLE</span></td>
        <td><span class="struct-badge struct-scalar">スカラー</span></td>
        <td><span class="desc-text">顧客の姓</span></td>
      </tr>
      <tr>
        <td class="col-num">5</td>
        <td><span class="field-name">display_name</span></td>
        <td><span class="bq-type">STRING</span></td>
        <td><span class="badge badge-required">REQUIRED</span></td>
        <td><span class="struct-badge struct-scalar">スカラー</span></td>
        <td><span class="desc-text">表示名（firstName+lastName、なければemail/phone）</span></td>
      </tr>

      <!-- default_email_address -->
      <tr class="expandable-row" data-target="email">
        <td class="col-num">6</td>
        <td><span class="field-name-wrap"><span class="expand-icon">▶</span><span class="field-name">default_email_address</span></span></td>
        <td><span class="bq-type">RECORD</span></td>
        <td><span class="badge badge-nullable">NULLABLE</span></td>
        <td><span class="struct-badge struct-record">オブジェクト</span></td>
        <td><span class="desc-text">デフォルトメールアドレス <a href="https://shopify.dev/docs/api/admin-graphql/latest/objects/CustomerEmailAddress" target="_blank">CustomerEmailAddress↗</a></span></td>
      </tr>
      <tr class="child-row" data-parent="email">
        <td class="col-num">6-1</td>
        <td><span class="field-name child">.email_address</span></td>
        <td><span class="bq-type">STRING</span></td>
        <td><span class="badge badge-nullable">NULLABLE</span></td>
        <td><span class="struct-badge struct-scalar">スカラー</span></td>
        <td><span class="desc-text">メールアドレス</span></td>
      </tr>
      <tr class="child-row" data-parent="email">
        <td class="col-num">6-2</td>
        <td><span class="field-name child">.marketing_state</span></td>
        <td><span class="bq-type">STRING</span></td>
        <td><span class="badge badge-nullable">NULLABLE</span></td>
        <td><span class="struct-badge struct-scalar">スカラー</span></td>
        <td><span class="desc-text">マーケティング同意状態（SUBSCRIBED / UNSUBSCRIBED / PENDING 等）</span></td>
      </tr>

      <!-- default_phone_number -->
      <tr class="expandable-row" data-target="phone">
        <td class="col-num">7</td>
        <td><span class="field-name-wrap"><span class="expand-icon">▶</span><span class="field-name">default_phone_number</span></span></td>
        <td><span class="bq-type">RECORD</span></td>
        <td><span class="badge badge-nullable">NULLABLE</span></td>
        <td><span class="struct-badge struct-record">オブジェクト</span></td>
        <td><span class="desc-text">デフォルト電話番号 <a href="https://shopify.dev/docs/api/admin-graphql/latest/objects/CustomerPhoneNumber" target="_blank">CustomerPhoneNumber↗</a></span></td>
      </tr>
      <tr class="child-row" data-parent="phone">
        <td class="col-num">7-1</td>
        <td><span class="field-name child">.phone_number</span></td>
        <td><span class="bq-type">STRING</span></td>
        <td><span class="badge badge-nullable">NULLABLE</span></td>
        <td><span class="struct-badge struct-scalar">スカラー</span></td>
        <td><span class="desc-text">電話番号</span></td>
      </tr>
      <tr class="child-row" data-parent="phone">
        <td class="col-num">7-2</td>
        <td><span class="field-name child">.marketing_state</span></td>
        <td><span class="bq-type">STRING</span></td>
        <td><span class="badge badge-nullable">NULLABLE</span></td>
        <td><span class="struct-badge struct-scalar">スカラー</span></td>
        <td><span class="desc-text">SMSマーケティング同意状態</span></td>
      </tr>
      <tr class="child-row" data-parent="phone">
        <td class="col-num">7-3</td>
        <td><span class="field-name child">.marketing_collected_from</span></td>
        <td><span class="bq-type">STRING</span></td>
        <td><span class="badge badge-nullable">NULLABLE</span></td>
        <td><span class="struct-badge struct-scalar">スカラー</span></td>
        <td><span class="desc-text">同意収集元</span></td>
      </tr>

      <!-- default_address -->
      <tr class="expandable-row" data-target="addr">
        <td class="col-num">8</td>
        <td><span class="field-name-wrap"><span class="expand-icon">▶</span><span class="field-name">default_address</span></span></td>
        <td><span class="bq-type">RECORD</span></td>
        <td><span class="badge badge-nullable">NULLABLE</span></td>
        <td><span class="struct-badge struct-record">オブジェクト</span></td>
        <td><span class="desc-text">デフォルト住所 <a href="https://shopify.dev/docs/api/admin-graphql/latest/objects/MailingAddress" target="_blank">MailingAddress↗</a></span></td>
      </tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-1</td><td><span class="field-name child">.id</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">住所ID</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-2</td><td><span class="field-name child">.first_name</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">名（住所用）</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-3</td><td><span class="field-name child">.last_name</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">姓（住所用）</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-4</td><td><span class="field-name child">.company</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">会社名</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-5</td><td><span class="field-name child">.address1</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">住所1行目</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-6</td><td><span class="field-name child">.address2</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">住所2行目</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-7</td><td><span class="field-name child">.city</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">市区町村</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-8</td><td><span class="field-name child">.province</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">都道府県</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-9</td><td><span class="field-name child">.province_code</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">都道府県コード</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-10</td><td><span class="field-name child">.country</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">国名</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-11</td><td><span class="field-name child">.country_code_v2</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">国コード（ISO 3166-1）</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-12</td><td><span class="field-name child">.zip</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">郵便番号</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-13</td><td><span class="field-name child">.phone</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">住所に紐づく電話番号</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-14</td><td><span class="field-name child">.name</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">名前（結合済み）</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-15</td><td><span class="field-name child">.formatted</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">フォーマット済み住所</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-16</td><td><span class="field-name child">.latitude</span></td><td><span class="bq-type">FLOAT64</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">緯度</span></td></tr>
      <tr class="child-row" data-parent="addr"><td class="col-num">8-17</td><td><span class="field-name child">.longitude</span></td><td><span class="bq-type">FLOAT64</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">経度</span></td></tr>

      <!-- amount_spent -->
      <tr class="expandable-row" data-target="spent">
        <td class="col-num">9</td>
        <td><span class="field-name-wrap"><span class="expand-icon">▶</span><span class="field-name">amount_spent</span></span></td>
        <td><span class="bq-type">RECORD</span></td>
        <td><span class="badge badge-required">REQUIRED</span></td>
        <td><span class="struct-badge struct-record">オブジェクト</span></td>
        <td><span class="desc-text">生涯累計購入金額 <a href="https://shopify.dev/docs/api/admin-graphql/latest/objects/MoneyV2" target="_blank">MoneyV2↗</a></span></td>
      </tr>
      <tr class="child-row" data-parent="spent"><td class="col-num">9-1</td><td><span class="field-name child">.amount</span></td><td><span class="bq-type">NUMERIC</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">金額</span></td></tr>
      <tr class="child-row" data-parent="spent"><td class="col-num">9-2</td><td><span class="field-name child">.currency_code</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">通貨コード</span></td></tr>

      <!-- scalars -->
      <tr><td class="col-num">10</td><td><span class="field-name">number_of_orders</span></td><td><span class="bq-type">INT64</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">生涯注文回数</span></td></tr>
      <tr><td class="col-num">11</td><td><span class="field-name">state</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">アカウント状態（DISABLED / INVITED / ENABLED / DECLINED）</span></td></tr>
      <tr><td class="col-num">12</td><td><span class="field-name">verified_email</span></td><td><span class="bq-type">BOOLEAN</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">メールアドレス確認済みか</span></td></tr>
      <tr><td class="col-num">13</td><td><span class="field-name">tax_exempt</span></td><td><span class="bq-type">BOOLEAN</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">免税対象か</span></td></tr>
      <tr><td class="col-num">14</td><td><span class="field-name">tax_exemptions</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-repeated">REPEATED</span></td><td><span class="struct-badge struct-list">リスト</span></td><td><span class="desc-text">適用されている免税種別のリスト</span></td></tr>
      <tr><td class="col-num">15</td><td><span class="field-name">tags</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-repeated">REPEATED</span></td><td><span class="struct-badge struct-list">リスト</span></td><td><span class="desc-text">顧客タグ</span></td></tr>
      <tr><td class="col-num">16</td><td><span class="field-name">note</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">顧客メモ</span></td></tr>
      <tr><td class="col-num">17</td><td><span class="field-name">locale</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">ロケール</span></td></tr>
      <tr><td class="col-num">18</td><td><span class="field-name">multipass_identifier</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">Multipassログイン用の識別子</span></td></tr>
      <tr><td class="col-num">19</td><td><span class="field-name">lifetime_duration</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">登録からの経過期間（例："about 12 years"）</span></td></tr>
      <tr><td class="col-num">20</td><td><span class="field-name">can_delete</span></td><td><span class="bq-type">BOOLEAN</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">削除可能か（注文なしの場合のみtrue）</span></td></tr>
      <tr><td class="col-num">21</td><td><span class="field-name">data_sale_opt_out</span></td><td><span class="bq-type">BOOLEAN</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">データ販売オプトアウト済みか</span></td></tr>
      <tr><td class="col-num">22</td><td><span class="field-name">product_subscriber_status</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">サブスク状態（ACTIVE / CANCELLED / EXPIRED / PAUSED / NEVER_SUBSCRIBED）</span></td></tr>
      <tr><td class="col-num">23</td><td><span class="field-name">created_at</span></td><td><span class="bq-type">TIMESTAMP</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">顧客登録日時</span></td></tr>
      <tr><td class="col-num">24</td><td><span class="field-name">updated_at</span></td><td><span class="bq-type">TIMESTAMP</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">最終更新日時</span></td></tr>

      <!-- image -->
      <tr class="expandable-row" data-target="img">
        <td class="col-num">25</td>
        <td><span class="field-name-wrap"><span class="expand-icon">▶</span><span class="field-name">image</span></span></td>
        <td><span class="bq-type">RECORD</span></td>
        <td><span class="badge badge-required">REQUIRED</span></td>
        <td><span class="struct-badge struct-record">オブジェクト</span></td>
        <td><span class="desc-text">顧客画像 <a href="https://shopify.dev/docs/api/admin-graphql/latest/objects/Image" target="_blank">Image↗</a></span></td>
      </tr>
      <tr class="child-row" data-parent="img"><td class="col-num">25-1</td><td><span class="field-name child">.url</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">画像URL</span></td></tr>
      <tr class="child-row" data-parent="img"><td class="col-num">25-2</td><td><span class="field-name child">.alt_text</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">代替テキスト</span></td></tr>
      <tr class="child-row" data-parent="img"><td class="col-num">25-3</td><td><span class="field-name child">.width</span></td><td><span class="bq-type">INT64</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">幅（px）</span></td></tr>
      <tr class="child-row" data-parent="img"><td class="col-num">25-4</td><td><span class="field-name child">.height</span></td><td><span class="bq-type">INT64</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">高さ（px）</span></td></tr>

      <!-- mergeable -->
      <tr class="expandable-row" data-target="merge">
        <td class="col-num">26</td>
        <td><span class="field-name-wrap"><span class="expand-icon">▶</span><span class="field-name">mergeable</span></span></td>
        <td><span class="bq-type">RECORD</span></td>
        <td><span class="badge badge-required">REQUIRED</span></td>
        <td><span class="struct-badge struct-record">オブジェクト</span></td>
        <td><span class="desc-text">マージ可否情報 <a href="https://shopify.dev/docs/api/admin-graphql/latest/objects/CustomerMergeable" target="_blank">CustomerMergeable↗</a></span></td>
      </tr>
      <tr class="child-row" data-parent="merge"><td class="col-num">26-1</td><td><span class="field-name child">.is_mergeable</span></td><td><span class="bq-type">BOOLEAN</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">マージ可能か</span></td></tr>
      <tr class="child-row" data-parent="merge"><td class="col-num">26-2</td><td><span class="field-name child">.reason</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">マージ不可の理由</span></td></tr>

      <!-- statistics -->
      <tr class="expandable-row" data-target="stats">
        <td class="col-num">27</td>
        <td><span class="field-name-wrap"><span class="expand-icon">▶</span><span class="field-name">statistics</span></span></td>
        <td><span class="bq-type">RECORD</span></td>
        <td><span class="badge badge-required">REQUIRED</span></td>
        <td><span class="struct-badge struct-record">オブジェクト</span></td>
        <td><span class="desc-text">顧客統計 <a href="https://shopify.dev/docs/api/admin-graphql/latest/objects/CustomerStatistics" target="_blank">CustomerStatistics↗</a></span></td>
      </tr>
      <tr class="child-row" data-parent="stats"><td class="col-num">27-1</td><td><span class="field-name child">.predicted_spend_tier</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">予測消費ティア（HIGH / MEDIUM / LOW）</span></td></tr>

      <!-- metafields -->
      <tr class="expandable-row" data-target="meta">
        <td class="col-num">28</td>
        <td><span class="field-name-wrap"><span class="expand-icon">▶</span><span class="field-name">metafields</span></span></td>
        <td><span class="bq-type">RECORD</span></td>
        <td><span class="badge badge-repeated">REPEATED</span></td>
        <td><span class="struct-badge struct-list">リスト</span></td>
        <td><span class="desc-text">カスタムフィールド <a href="https://shopify.dev/docs/api/admin-graphql/latest/objects/Metafield" target="_blank">Metafield↗</a></span></td>
      </tr>
      <tr class="child-row" data-parent="meta"><td class="col-num">28-1</td><td><span class="field-name child">.id</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">メタフィールドID</span></td></tr>
      <tr class="child-row" data-parent="meta"><td class="col-num">28-2</td><td><span class="field-name child">.namespace</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">名前空間</span></td></tr>
      <tr class="child-row" data-parent="meta"><td class="col-num">28-3</td><td><span class="field-name child">.key</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">キー</span></td></tr>
      <tr class="child-row" data-parent="meta"><td class="col-num">28-4</td><td><span class="field-name child">.value</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">値</span></td></tr>
      <tr class="child-row" data-parent="meta"><td class="col-num">28-5</td><td><span class="field-name child">.type</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">値の型定義</span></td></tr>
      <tr class="child-row" data-parent="meta"><td class="col-num">28-6</td><td><span class="field-name child">.created_at</span></td><td><span class="bq-type">TIMESTAMP</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">作成日時</span></td></tr>
      <tr class="child-row" data-parent="meta"><td class="col-num">28-7</td><td><span class="field-name child">.updated_at</span></td><td><span class="bq-type">TIMESTAMP</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">更新日時</span></td></tr>

      <!-- loaded_date -->
      <tr>
        <td class="col-num">29</td>
        <td><span class="field-name">loaded_date</span></td>
        <td><span class="bq-type">DATE</span></td>
        <td><span class="badge badge-required">REQUIRED</span></td>
        <td><span class="struct-badge struct-scalar">スカラー</span></td>
        <td><span class="desc-text">BigQuery取込日（パーティションキー）※API項目ではなく取込時に付与</span></td>
      </tr>
    </tbody>
  </table>
</div>

<!-- ==================== raw_shopify_customer_addresses ==================== -->
<div class="table-wrap">
  <div class="table-title"><code>raw_shopify_customer_addresses</code></div>
  <table>
    <thead>
      <tr>
        <th class="col-num">#</th>
        <th class="col-field">フィールド名</th>
        <th class="col-bqtype">BQ型</th>
        <th class="col-mode">モード</th>
        <th class="col-struct">構造</th>
        <th class="col-desc">説明</th>
      </tr>
    </thead>
    <tbody>
      <tr><td class="col-num">1</td><td><span class="field-name">customer_id</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">親の顧客ID（結合キー）</span></td></tr>
      <tr><td class="col-num">2</td><td><span class="field-name">id</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">住所ID</span></td></tr>
      <tr><td class="col-num">3</td><td><span class="field-name">first_name</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">名（住所用）</span></td></tr>
      <tr><td class="col-num">4</td><td><span class="field-name">last_name</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">姓（住所用）</span></td></tr>
      <tr><td class="col-num">5</td><td><span class="field-name">company</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">会社名</span></td></tr>
      <tr><td class="col-num">6</td><td><span class="field-name">address1</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">住所1行目</span></td></tr>
      <tr><td class="col-num">7</td><td><span class="field-name">address2</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">住所2行目</span></td></tr>
      <tr><td class="col-num">8</td><td><span class="field-name">city</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">市区町村</span></td></tr>
      <tr><td class="col-num">9</td><td><span class="field-name">province</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">都道府県</span></td></tr>
      <tr><td class="col-num">10</td><td><span class="field-name">province_code</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">都道府県コード</span></td></tr>
      <tr><td class="col-num">11</td><td><span class="field-name">country</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">国名</span></td></tr>
      <tr><td class="col-num">12</td><td><span class="field-name">country_code_v2</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">国コード（ISO 3166-1）</span></td></tr>
      <tr><td class="col-num">13</td><td><span class="field-name">zip</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">郵便番号</span></td></tr>
      <tr><td class="col-num">14</td><td><span class="field-name">phone</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">住所に紐づく電話番号</span></td></tr>
      <tr><td class="col-num">15</td><td><span class="field-name">name</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">名前（結合済み）</span></td></tr>
      <tr><td class="col-num">16</td><td><span class="field-name">formatted</span></td><td><span class="bq-type">STRING</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">フォーマット済み住所</span></td></tr>
      <tr><td class="col-num">17</td><td><span class="field-name">latitude</span></td><td><span class="bq-type">FLOAT64</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">緯度</span></td></tr>
      <tr><td class="col-num">18</td><td><span class="field-name">longitude</span></td><td><span class="bq-type">FLOAT64</span></td><td><span class="badge badge-nullable">NULLABLE</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">経度</span></td></tr>
      <tr><td class="col-num">19</td><td><span class="field-name">is_default</span></td><td><span class="bq-type">BOOLEAN</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">この住所がdefaultAddressか</span></td></tr>
      <tr><td class="col-num">20</td><td><span class="field-name">loaded_date</span></td><td><span class="bq-type">DATE</span></td><td><span class="badge badge-required">REQUIRED</span></td><td><span class="struct-badge struct-scalar">スカラー</span></td><td><span class="desc-text">BigQuery取込日（パーティションキー）</span></td></tr>
    </tbody>
  </table>
</div>

<!-- ==================== Connection一覧 ==================== -->
<div class="table-wrap connection-table">
  <div class="table-title">別テーブルで管理するConnection一覧</div>
  <table>
    <thead>
      <tr>
        <th>Connection</th>
        <th>対応テーブル</th>
        <th>備考</th>
      </tr>
    </thead>
    <tbody>
      <tr><td><span class="field-name">addressesV2</span></td><td><code>raw_shopify_customer_addresses</code></td><td><span class="desc-text">上記で定義済み</span></td></tr>
      <tr><td><span class="field-name">orders</span></td><td><code>raw_shopify_orders</code></td><td><span class="desc-text">Orderオブジェクトとして別途定義</span></td></tr>
      <tr><td><span class="field-name">paymentMethods</span></td><td><span class="badge-scope">スコープ外</span></td><td><span class="desc-text">決済手段管理</span></td></tr>
      <tr><td><span class="field-name">storeCreditAccounts</span></td><td><span class="badge-scope">スコープ外</span></td><td><span class="desc-text">ストアクレジット</span></td></tr>
      <tr><td><span class="field-name">subscriptionContracts</span></td><td><span class="badge-scope">スコープ外</span></td><td><span class="desc-text">サブスク契約</span></td></tr>
      <tr><td><span class="field-name">events</span></td><td><span class="badge-scope">スコープ外</span></td><td><span class="desc-text">顧客イベントログ</span></td></tr>
      <tr><td><span class="field-name">companyContactProfiles</span></td><td><span class="badge-scope">スコープ外</span></td><td><span class="desc-text">B2B用</span></td></tr>
    </tbody>
  </table>
</div>

</div>

<script>
document.querySelectorAll('.expandable-row').forEach(row => {
  row.addEventListener('click', () => {
    const target = row.dataset.target;
    const isExpanded = row.classList.toggle('expanded');
    document.querySelectorAll(`.child-row[data-parent="${target}"]`).forEach(child => {
      child.classList.toggle('visible', isExpanded);
    });
  });
});
</script>
</body>
</html>
