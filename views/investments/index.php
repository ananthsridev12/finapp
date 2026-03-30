<?php
$activeModule    = 'investments';
$investments     = $investments     ?? [];
$transactions    = $transactions    ?? [];
$accounts        = $accounts        ?? [];
$summary         = $summary         ?? ['count' => 0, 'total_invested' => 0, 'total_redeemed' => 0, 'current_value' => 0];
$editInvestment  = $editInvestment  ?? null;

$totalInvested  = (float) ($summary['total_invested']  ?? 0);
$totalRedeemed  = (float) ($summary['total_redeemed']  ?? 0);
$currentValue   = (float) ($summary['current_value']   ?? 0);
$netInvested    = $totalInvested - $totalRedeemed;
$pnl            = $currentValue - $netInvested;
$pnlPct         = $netInvested > 0 ? ($pnl / $netInvested) * 100 : 0;

$instrumentTypes = ['mutual_fund', 'equity', 'etf'];

include __DIR__ . '/../partials/nav.php';
?>
<style>
/* ── Investment-specific styles ─────────────────────────── */
.pnl-pos { color: #22c55e; font-weight: 700; }
.pnl-neg { color: #ef4444; font-weight: 700; }

/* Type badges */
.type-badge {
    display: inline-block; font-size: 0.65rem; font-weight: 700;
    border-radius: 999px; padding: 0.15rem 0.55rem;
    text-transform: uppercase; letter-spacing: 0.05em; white-space: nowrap;
}
.type-badge--mutual_fund { background: rgba(59,130,246,0.15);  color: #93c5fd; }
.type-badge--equity      { background: rgba(34,197,94,0.15);   color: #86efac; }
.type-badge--etf         { background: rgba(34,211,238,0.15);  color: #67e8f9; }
.type-badge--fd          { background: rgba(234,179,8,0.15);   color: #fde047; }
.type-badge--rd          { background: rgba(249,115,22,0.15);  color: #fdba74; }
.type-badge--other       { background: rgba(148,163,184,0.15); color: #94a3b8; }

/* Price badge */
.price-badge {
    display: inline-block; font-size: 0.7rem; font-weight: 600;
    background: rgba(168,85,247,0.15); color: #d8b4fe;
    border-radius: 6px; padding: 0.15rem 0.5rem;
}

/* Instrument search */
.instrument-search-wrap { position: relative; }
.instrument-dropdown {
    position: absolute; top: calc(100% + 4px); left: 0; right: 0; z-index: 200;
    background: #0f1a2e; border: 1px solid rgba(120,150,210,0.28);
    border-radius: 10px; box-shadow: 0 8px 32px rgba(0,0,0,0.5);
    max-height: 260px; overflow-y: auto;
    display: none;
}
.instrument-dropdown.open { display: block; }
.instrument-dropdown-item {
    padding: 0.6rem 0.85rem; cursor: pointer;
    border-bottom: 1px solid rgba(120,150,210,0.1);
    display: flex; align-items: center; gap: 0.55rem;
    transition: background 0.15s;
}
.instrument-dropdown-item:last-child { border-bottom: none; }
.instrument-dropdown-item:hover { background: rgba(59,130,246,0.1); }
.instrument-dropdown-item .ins-name { font-size: 0.88rem; color: #e5ecff; flex: 1; min-width: 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.instrument-dropdown-item .ins-isin { font-size: 0.7rem; color: #7a94c4; }
.instrument-selected-info {
    grid-column: 1 / -1;
    background: rgba(34,197,94,0.07); border: 1px solid rgba(34,197,94,0.2);
    border-radius: 10px; padding: 0.65rem 0.9rem;
    display: none; gap: 0.75rem; align-items: center; flex-wrap: wrap;
    font-size: 0.82rem;
}
.instrument-selected-info.visible { display: flex; }
.instrument-selected-info .sel-name { font-weight: 600; color: #e5ecff; }
.instrument-selected-info .sel-isin { color: #7a94c4; }

/* Collapsible panel toggle */
.panel-toggle-btn {
    background: none; border: none; color: var(--muted); cursor: pointer;
    font-size: 0.8rem; font-family: inherit; padding: 0; display: inline-flex; align-items: center; gap: 0.4rem;
    transition: color 0.15s;
}
.panel-toggle-btn:hover { color: var(--text); }
.panel-toggle-btn .arrow { transition: transform 0.2s; }
.panel-toggle-btn.open .arrow { transform: rotate(180deg); }
.panel-collapsible { display: none; }
.panel-collapsible.open { display: block; }

/* Instrument field groups inside form */
.inv-instrument-fields,
.inv-plain-name-fields { grid-column: 1 / -1; display: none; }
.inv-instrument-fields.visible,
.inv-plain-name-fields.visible {
    display: grid; grid-template-columns: repeat(2, 1fr); gap: 1rem;
}
@media (max-width: 600px) {
    .inv-instrument-fields.visible,
    .inv-plain-name-fields.visible { grid-template-columns: 1fr; }
}

/* Units auto-calc inline button */
.input-with-btn { display: flex; gap: 0.5rem; align-items: flex-end; }
.input-with-btn input { flex: 1; }
.calc-btn {
    border: 1px solid var(--line); background: rgba(59,130,246,0.1);
    color: var(--accent); border-radius: var(--radius-sm);
    padding: 0.6rem 0.75rem; font-size: 0.75rem; font-weight: 600;
    cursor: pointer; white-space: nowrap; transition: all 0.15s; flex-shrink: 0;
    margin-top: 0.4rem;
}
.calc-btn:hover { background: rgba(59,130,246,0.2); border-color: var(--accent); }

/* Table: dash for missing data */
.dash { color: #7a94c4; }

/* Txn-type badge in table */
.txn-badge { display:inline-block; font-size:0.65rem; font-weight:700; border-radius:999px; padding:0.15rem 0.55rem; text-transform:uppercase; letter-spacing:0.04em; }
.txn-badge--buy      { background:rgba(34,197,94,0.15);  color:#86efac; }
.txn-badge--sell     { background:rgba(244,63,94,0.15);   color:#fda4af; }
.txn-badge--dividend { background:rgba(234,179,8,0.15);  color:#fde047; }
</style>

<main class="module-content">
    <header class="module-header">
        <h1>Investments</h1>
        <p>Track mutual funds, equities, ETFs, FD/RD locks and keep every transaction immutable.</p>
    </header>

    <!-- ── Summary cards ───────────────────────────────────── -->
    <section class="summary-cards">
        <article class="card">
            <h3>Investments</h3>
            <p><?= (int) $summary['count'] ?></p>
        </article>
        <article class="card card--cyan">
            <h3>Total Invested</h3>
            <p><?= formatCurrency($totalInvested) ?></p>
            <?php if ($totalRedeemed > 0): ?>
                <small>Redeemed: <?= formatCurrency($totalRedeemed) ?></small>
            <?php endif; ?>
        </article>
        <article class="card card--purple">
            <h3>Current Value</h3>
            <p><?= formatCurrency($currentValue) ?></p>
        </article>
        <article class="card <?= $pnl >= 0 ? 'card--green' : 'card--red' ?>">
            <h3>P&amp;L</h3>
            <p class="<?= $pnl >= 0 ? 'pnl-pos' : 'pnl-neg' ?>"><?= ($pnl >= 0 ? '+' : '') . formatCurrency($pnl) ?></p>
            <?php if ($netInvested > 0): ?>
                <small class="<?= $pnlPct >= 0 ? 'pnl-pos' : 'pnl-neg' ?>"><?= ($pnlPct >= 0 ? '+' : '') . number_format($pnlPct, 2) ?>%</small>
            <?php endif; ?>
        </article>
    </section>

    <!-- ── New / Edit investment ───────────────────────────── -->
    <section class="module-panel">
        <h2 style="display:flex;justify-content:space-between;align-items:center;">
            <?= $editInvestment ? 'Edit investment' : 'New investment' ?>
            <?php if (!$editInvestment): ?>
                <button class="panel-toggle-btn" id="inv-form-toggle" onclick="toggleInvForm()">
                    <span id="inv-form-toggle-label">Show</span>
                    <span class="arrow">&#9660;</span>
                </button>
            <?php endif; ?>
        </h2>
        <div class="panel-collapsible <?= $editInvestment ? 'open' : '' ?>" id="inv-form-body">
            <form method="post" class="module-form" id="inv-form">
                <?php if ($editInvestment): ?>
                    <input type="hidden" name="form" value="investment_update">
                    <input type="hidden" name="id" value="<?= (int) $editInvestment['id'] ?>">
                <?php else: ?>
                    <input type="hidden" name="form" value="investment">
                <?php endif; ?>

                <!-- Type selector -->
                <label>
                    Type
                    <select name="type" id="inv-type-select" onchange="onInvTypeChange(this.value)">
                        <option value="mutual_fund" <?= ($editInvestment['type'] ?? 'mutual_fund') === 'mutual_fund' ? 'selected' : '' ?>>Mutual Fund</option>
                        <option value="equity"      <?= ($editInvestment['type'] ?? '') === 'equity'      ? 'selected' : '' ?>>Equity</option>
                        <option value="etf"         <?= ($editInvestment['type'] ?? '') === 'etf'         ? 'selected' : '' ?>>ETF</option>
                        <option value="fd"          <?= ($editInvestment['type'] ?? '') === 'fd'          ? 'selected' : '' ?>>FD</option>
                        <option value="rd"          <?= ($editInvestment['type'] ?? '') === 'rd'          ? 'selected' : '' ?>>RD</option>
                        <option value="other"       <?= ($editInvestment['type'] ?? '') === 'other'       ? 'selected' : '' ?>>Other</option>
                    </select>
                </label>

                <!-- Spacer to keep grid balanced -->
                <div></div>

                <!-- Instrument search fields (mutual_fund / equity / etf) -->
                <div class="inv-instrument-fields" id="inv-instrument-fields">
                    <label style="grid-column:1/-1;position:relative;">
                        Search instrument
                        <div class="instrument-search-wrap">
                            <input type="text" id="instrument_search" placeholder="Type fund name, ISIN or symbol…" autocomplete="off">
                            <div class="instrument-dropdown" id="instrument_dropdown"></div>
                        </div>
                    </label>
                    <input type="hidden" name="instrument_id" id="instrument_id_input"
                           value="<?= htmlspecialchars((string) ($editInvestment['instrument_id'] ?? '')) ?>">
                    <input type="hidden" name="name" id="instrument_name_hidden"
                           value="<?= htmlspecialchars($editInvestment['name'] ?? '') ?>">

                    <div class="instrument-selected-info <?= !empty($editInvestment['instrument_id']) ? 'visible' : '' ?>" id="instrument_selected_info">
                        <span class="sel-name" id="sel_name"><?= htmlspecialchars($editInvestment['name'] ?? '') ?></span>
                        <span class="sel-isin" id="sel_isin"></span>
                        <span class="price-badge" id="sel_price"></span>
                        <button type="button" onclick="clearInstrument()" class="secondary" style="margin-left:auto;font-size:0.72rem;">Clear</button>
                    </div>
                </div>

                <!-- Plain name field (fd / rd / other) -->
                <div class="inv-plain-name-fields" id="inv-plain-name-fields">
                    <label>
                        Name
                        <input type="text" name="name" id="plain_name_input"
                               value="<?= htmlspecialchars($editInvestment['name'] ?? '') ?>"
                               placeholder="e.g. SBI FD 2024">
                    </label>
                </div>

                <!-- Notes (full width) -->
                <label style="grid-column:1/-1;">
                    Notes
                    <textarea name="notes" rows="2"><?= htmlspecialchars($editInvestment['notes'] ?? '') ?></textarea>
                </label>

                <button type="submit"><?= $editInvestment ? 'Update investment' : 'Create investment' ?></button>
                <?php if ($editInvestment): ?>
                    <a class="secondary" href="?module=investments">Cancel</a>
                <?php endif; ?>
            </form>
        </div>
    </section>

    <!-- ── Investment transaction ──────────────────────────── -->
    <section class="module-panel">
        <h2 style="display:flex;justify-content:space-between;align-items:center;">
            Investment transaction
            <button class="panel-toggle-btn" id="txn-form-toggle" onclick="toggleTxnForm()">
                <span id="txn-form-toggle-label">Show</span>
                <span class="arrow">&#9660;</span>
            </button>
        </h2>
        <div class="panel-collapsible" id="txn-form-body">
            <form method="post" class="module-form" id="txn-form">
                <input type="hidden" name="form" value="investment_transaction">
                <label>
                    Investment
                    <select name="investment_id" id="txn_investment_id" required onchange="onTxnInvestmentChange(this.value)">
                        <?php foreach ($investments as $inv): ?>
                            <option value="<?= (int) $inv['id'] ?>"
                                    data-price="<?= htmlspecialchars((string) ($inv['current_price'] ?? '')) ?>"
                                    data-type="<?= htmlspecialchars($inv['type']) ?>">
                                <?= htmlspecialchars($inv['name']) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </label>
                <label>
                    Transaction type
                    <select name="transaction_type" id="txn_type_select">
                        <option value="buy">Buy</option>
                        <option value="sell">Sell</option>
                        <option value="dividend">Dividend</option>
                    </select>
                </label>
                <label>
                    Amount
                    <input type="number" name="amount" id="txn_amount" step="0.01" min="0" required placeholder="0.00" oninput="clearUnitsIfManual()">
                </label>
                <label>
                    NAV / Price per unit
                    <input type="number" name="nav_price" id="txn_nav_price" step="0.0001" min="0" placeholder="Leave blank to use current price" oninput="clearUnitsIfManual()">
                </label>
                <label>
                    Units
                    <div class="input-with-btn">
                        <input type="number" name="units" id="txn_units" step="0.0001" min="0" placeholder="0.0000">
                        <button type="button" class="calc-btn" onclick="calcUnits()" title="Calculate units from amount / price">Calc</button>
                    </div>
                </label>
                <label>
                    Date
                    <input type="date" name="transaction_date" value="<?= date('Y-m-d') ?>" required>
                </label>
                <label>
                    Account
                    <select name="account_id">
                        <option value="">None</option>
                        <?php foreach ($accounts as $account): ?>
                            <option value="<?= (int) $account['id'] ?>">
                                <?= htmlspecialchars($account['bank_name'] . ' — ' . $account['account_name']) ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                </label>
                <label style="grid-column:1/-1;">
                    Notes
                    <textarea name="notes" rows="2"></textarea>
                </label>
                <button type="submit">Save transaction</button>
            </form>
        </div>
    </section>

    <!-- ── Portfolio table ─────────────────────────────────── -->
    <section class="module-panel">
        <h2>Investment portfolio</h2>
        <?php if (empty($investments)): ?>
            <p class="muted">No investment records yet.</p>
        <?php else: ?>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Type</th>
                            <th>ISIN</th>
                            <th>Units</th>
                            <th>Avg Price</th>
                            <th>Current Price</th>
                            <th>Current Value</th>
                            <th>Invested</th>
                            <th>P&amp;L</th>
                            <th>P&amp;L%</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($investments as $inv):
                            $iType        = $inv['type'] ?? 'other';
                            $isInstrument = in_array($iType, $instrumentTypes, true);
                            $units        = (float) ($inv['total_units']   ?? 0);
                            $invested     = (float) ($inv['total_invested'] ?? 0);
                            $redeemed     = (float) ($inv['total_redeemed'] ?? 0);
                            $curPrice     = $inv['current_price'] !== null ? (float) $inv['current_price'] : null;
                            $netInv       = $invested - $redeemed;

                            if ($isInstrument && $curPrice !== null && $units > 0) {
                                $curVal  = $units * $curPrice;
                                $avgPx   = $units > 0 ? ($netInv / $units) : null;
                                $rowPnl  = $curVal - $netInv;
                                $rowPct  = $netInv > 0 ? ($rowPnl / $netInv) * 100 : null;
                            } else {
                                $curVal  = null;
                                $avgPx   = null;
                                $rowPnl  = null;
                                $rowPct  = null;
                            }

                            $typeBadgeClass = 'type-badge--' . $iType;
                            $typeLabel = match($iType) {
                                'mutual_fund' => 'MF',
                                'equity'      => 'EQ',
                                'etf'         => 'ETF',
                                'fd'          => 'FD',
                                'rd'          => 'RD',
                                default       => 'Other',
                            };
                        ?>
                        <tr>
                            <td><?= htmlspecialchars($inv['name']) ?></td>
                            <td><span class="type-badge <?= $typeBadgeClass ?>"><?= $typeLabel ?></span></td>
                            <td><?= $inv['isin'] ? '<small>' . htmlspecialchars($inv['isin']) . '</small>' : '<span class="dash">—</span>' ?></td>
                            <td><?= $units > 0 ? number_format($units, 4) : '<span class="dash">—</span>' ?></td>
                            <td><?= $avgPx !== null ? formatCurrency($avgPx) : '<span class="dash">—</span>' ?></td>
                            <td><?= $curPrice !== null ? '<span class="price-badge">' . formatCurrency($curPrice) . '</span>' : '<span class="dash">—</span>' ?></td>
                            <td><?= $curVal !== null ? formatCurrency($curVal) : '<span class="dash">—</span>' ?></td>
                            <td><?= $invested > 0 ? formatCurrency($netInv) : '<span class="dash">—</span>' ?></td>
                            <td>
                                <?php if ($rowPnl !== null): ?>
                                    <span class="<?= $rowPnl >= 0 ? 'pnl-pos' : 'pnl-neg' ?>"><?= ($rowPnl >= 0 ? '+' : '') . formatCurrency($rowPnl) ?></span>
                                <?php else: ?>
                                    <span class="dash">—</span>
                                <?php endif; ?>
                            </td>
                            <td>
                                <?php if ($rowPct !== null): ?>
                                    <span class="<?= $rowPct >= 0 ? 'pnl-pos' : 'pnl-neg' ?>"><?= ($rowPct >= 0 ? '+' : '') . number_format($rowPct, 2) ?>%</span>
                                <?php else: ?>
                                    <span class="dash">—</span>
                                <?php endif; ?>
                            </td>
                            <td><a class="secondary" href="?module=investments&edit=<?= (int) $inv['id'] ?>">Edit</a></td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </section>

    <!-- ── Recent transactions ─────────────────────────────── -->
    <section class="module-panel">
        <h2>Recent investment transactions</h2>
        <?php if (empty($transactions)): ?>
            <p class="muted">No investment transactions yet.</p>
        <?php else: ?>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Investment</th>
                            <th>Type</th>
                            <th>Amount</th>
                            <th>Units</th>
                            <th>Account</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($transactions as $txn):
                            $txClass = 'txn-badge--' . ($txn['transaction_type'] ?? 'buy');
                        ?>
                        <tr>
                            <td><?= htmlspecialchars($txn['transaction_date']) ?></td>
                            <td><?= htmlspecialchars($txn['investment_name'] ?? '?') ?></td>
                            <td><span class="txn-badge <?= $txClass ?>"><?= htmlspecialchars(ucfirst($txn['transaction_type'] ?? '')) ?></span></td>
                            <td><?= formatCurrency((float) $txn['amount']) ?></td>
                            <td><?= ($txn['units'] !== null && (float)$txn['units'] > 0) ? number_format((float)$txn['units'], 4) : '<span class="dash">—</span>' ?></td>
                            <td><?= htmlspecialchars($txn['account_name'] ?? '—') ?></td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </section>
</main>

<script>
// ── Instrument price map (populated from PHP investments array) ──────────
const invPriceMap = {
    <?php foreach ($investments as $inv): ?>
    <?= (int)$inv['id'] ?>: <?= ($inv['current_price'] !== null) ? (float)$inv['current_price'] : 'null' ?>,
    <?php endforeach; ?>
};

// ── Collapsible panels ───────────────────────────────────────────────────
function toggleInvForm() {
    const body  = document.getElementById('inv-form-body');
    const btn   = document.getElementById('inv-form-toggle');
    const label = document.getElementById('inv-form-toggle-label');
    const open  = body.classList.toggle('open');
    btn.classList.toggle('open', open);
    label.textContent = open ? 'Hide' : 'Show';
}
function toggleTxnForm() {
    const body  = document.getElementById('txn-form-body');
    const btn   = document.getElementById('txn-form-toggle');
    const label = document.getElementById('txn-form-toggle-label');
    const open  = body.classList.toggle('open');
    btn.classList.toggle('open', open);
    label.textContent = open ? 'Hide' : 'Show';
}

// ── Investment form: show/hide instrument vs plain-name fields ───────────
const INSTRUMENT_TYPES = ['mutual_fund', 'equity', 'etf'];

function onInvTypeChange(type) {
    const iFields   = document.getElementById('inv-instrument-fields');
    const pFields   = document.getElementById('inv-plain-name-fields');
    const plainInput = document.getElementById('plain_name_input');
    const nameHidden = document.getElementById('instrument_name_hidden');
    if (INSTRUMENT_TYPES.includes(type)) {
        iFields.classList.add('visible');
        pFields.classList.remove('visible');
        plainInput.removeAttribute('required');
        plainInput.disabled  = true;   // excluded from form submit
        nameHidden.disabled  = false;
    } else {
        iFields.classList.remove('visible');
        pFields.classList.add('visible');
        plainInput.setAttribute('required', 'required');
        plainInput.disabled  = false;
        nameHidden.disabled  = true;   // excluded from form submit
        clearInstrument();
    }
}

// Initialise on page load
(function () {
    const sel = document.getElementById('inv-type-select');
    if (sel) onInvTypeChange(sel.value);
    <?php if ($editInvestment): ?>
    // If editing, open the form panel immediately
    document.getElementById('inv-form-body').classList.add('open');
    <?php endif; ?>
})();

// ── Instrument search / autocomplete ────────────────────────────────────
let searchTimer  = null;
let searchAbort  = null;

document.addEventListener('DOMContentLoaded', function () {
    const searchInput = document.getElementById('instrument_search');
    const dropdown    = document.getElementById('instrument_dropdown');
    if (!searchInput) return;

    searchInput.addEventListener('input', function () {
        clearTimeout(searchTimer);
        const q = this.value.trim();
        if (q.length < 2) { closeDropdown(); return; }
        searchTimer = setTimeout(() => doSearch(q), 350);
    });

    document.addEventListener('click', function (e) {
        if (!searchInput.contains(e.target) && !dropdown.contains(e.target)) {
            closeDropdown();
        }
    });
});

function doSearch(q) {
    // Abort any in-flight request before firing a new one
    if (searchAbort) { searchAbort.abort(); }
    searchAbort = new AbortController();

    const typeSelect = document.getElementById('inv-type-select');
    const type       = typeSelect ? typeSelect.value : '';
    const url        = '?module=investments&action=search_instrument&q=' + encodeURIComponent(q) + '&type=' + encodeURIComponent(type);
    fetch(url, { signal: searchAbort.signal })
        .then(r => r.json())
        .then(data => renderDropdown(data))
        .catch(err => { if (err.name !== 'AbortError') closeDropdown(); });
}

function renderDropdown(items) {
    const dropdown = document.getElementById('instrument_dropdown');
    if (!items || items.length === 0) { closeDropdown(); return; }
    dropdown.innerHTML = '';
    items.forEach(item => {
        const el   = document.createElement('div');
        el.className = 'instrument-dropdown-item';
        const price = item.current_price != null ? formatCurrencyJS(item.current_price) : '—';
        el.innerHTML =
            '<span class="ins-name">' + escHtml(item.name || item.scheme_name || '') + '</span>' +
            '<span class="type-badge type-badge--' + escHtml(item.type || '') + '" style="flex-shrink:0;">' + escHtml((item.type || '').toUpperCase()) + '</span>' +
            '<span class="ins-isin">' + escHtml(item.isin || '') + '</span>' +
            '<span class="price-badge" style="flex-shrink:0;">' + price + '</span>';
        el.addEventListener('click', () => selectInstrument(item));
        dropdown.appendChild(el);
    });
    dropdown.classList.add('open');
}

function selectInstrument(item) {
    document.getElementById('instrument_id_input').value   = item.id || '';
    document.getElementById('instrument_name_hidden').value = item.name || item.scheme_name || '';
    document.getElementById('instrument_search').value      = item.name || item.scheme_name || '';

    const info = document.getElementById('instrument_selected_info');
    document.getElementById('sel_name').textContent  = item.name || item.scheme_name || '';
    document.getElementById('sel_isin').textContent  = item.isin ? ('ISIN: ' + item.isin) : '';
    const priceEl = document.getElementById('sel_price');
    priceEl.textContent = item.current_price != null ? ('₹ ' + parseFloat(item.current_price).toFixed(4)) : '';
    priceEl.style.display = item.current_price != null ? '' : 'none';
    info.classList.add('visible');
    closeDropdown();
}

function clearInstrument() {
    const idInput    = document.getElementById('instrument_id_input');
    const nameHidden = document.getElementById('instrument_name_hidden');
    const searchEl   = document.getElementById('instrument_search');
    const info       = document.getElementById('instrument_selected_info');
    if (idInput)    idInput.value    = '';
    if (nameHidden) nameHidden.value = '';
    if (searchEl)   searchEl.value  = '';
    if (info)       info.classList.remove('visible');
}

function closeDropdown() {
    const d = document.getElementById('instrument_dropdown');
    if (d) { d.classList.remove('open'); d.innerHTML = ''; }
}

// ── Transaction form helpers ─────────────────────────────────────────────
function onTxnInvestmentChange(id) {
    // Optionally pre-fill NAV price from current price
    const price = invPriceMap[parseInt(id)];
    const navEl = document.getElementById('txn_nav_price');
    if (navEl && price != null) navEl.placeholder = 'Current: ' + formatCurrencyJS(price);
    else if (navEl) navEl.placeholder = 'Leave blank to use current price';
}

function calcUnits() {
    const amount   = parseFloat(document.getElementById('txn_amount').value)    || 0;
    const navInput = document.getElementById('txn_nav_price').value;
    const invId    = document.getElementById('txn_investment_id').value;
    let price      = navInput ? parseFloat(navInput) : null;
    if (!price && invId) price = invPriceMap[parseInt(invId)] || null;
    if (amount > 0 && price > 0) {
        document.getElementById('txn_units').value = (amount / price).toFixed(4);
    }
}

let _unitsManual = false;
function clearUnitsIfManual() { _unitsManual = false; }

// ── Utility ──────────────────────────────────────────────────────────────
function escHtml(str) {
    return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
}
function formatCurrencyJS(n) {
    return '₹' + parseFloat(n).toLocaleString('en-IN', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}

// Initialise txn investment select
(function () {
    const sel = document.getElementById('txn_investment_id');
    if (sel && sel.value) onTxnInvestmentChange(sel.value);
})();
</script>
