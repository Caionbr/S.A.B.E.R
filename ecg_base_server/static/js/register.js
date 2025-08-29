import { store, addPatient, updatePatient, deletePatient, getPatients } from './store.js';

const $ = (id)=>document.getElementById(id);
let editingId = null;

function uid(){ return 'p_' + Math.random().toString(36).slice(2,8) + Date.now().toString(36).slice(-4); }
function fmtDOB(s){ if(!s) return ''; try{ const d=new Date(s); const y=d.getFullYear(); const m=String(d.getMonth()+1).padStart(2,'0'); const dd=String(d.getDate()).padStart(2,'0'); return `${y}-${m}-${dd}`; }catch{ return s; } }

function clearNewForm(){
  ['new_fullname','new_pid','new_dob','new_sex','new_email','new_phone','new_notes']
    .forEach(id=>{ const el=$(id); if(el) el.value=''; });
}

function renderList(){
  const q = ($('search')?.value || '').trim().toLowerCase();
  const tbody = $('ptTable'); if(!tbody) return;
  tbody.innerHTML = '';
  const rows = getPatients().filter(p=>{
    if(!q) return true;
    return (p.fullname||'').toLowerCase().includes(q) || (p.pid||'').toLowerCase().includes(q);
  });
  if(rows.length===0){
    const tr = document.createElement('tr');
    tr.innerHTML = `<td colspan="5" style="color:#94a3b8">No patients found.</td>`;
    tbody.appendChild(tr); return;
  }
  rows.forEach(p=>{
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${p.fullname||''}</td>
      <td>${p.pid||''}</td>
      <td>${fmtDOB(p.dob)||''}</td>
      <td>${p.sex||''}</td>
      <td class="right">
        <button class="btn" data-act="edit" data-id="${p.uid}">Edit</button>
        <button class="btn warn" data-act="del" data-id="${p.uid}">Delete</button>
      </td>`;
    tbody.appendChild(tr);
  });
}

function openEditor(uidVal){
  const p = getPatients().find(x=>x.uid===uidVal);
  if(!p) return;
  editingId = uidVal;
  $('edit_fullname').value = p.fullname || '';
  $('edit_pid').value      = p.pid || '';
  $('edit_dob').value      = fmtDOB(p.dob) || '';
  $('edit_sex').value      = p.sex || '';
  $('edit_email').value    = p.email || '';
  $('edit_phone').value    = p.phone || '';
  $('edit_notes').value    = p.notes || '';
  $('editMsg').textContent = '';
  $('editCard').classList.remove('hidden');
  $('editCard').scrollIntoView({ behavior: 'smooth', block: 'start' });
}
function closeEditor(){
  $('editCard').classList.add('hidden');
  editingId = null;
}
function saveEditor(){
  if(!editingId) return;
  const ix = getPatients().findIndex(x=>x.uid===editingId);
  if(ix<0) return;
  const fullname = $('edit_fullname').value.trim();
  const pid      = $('edit_pid').value.trim();
  if(!fullname || !pid){ $('editMsg').textContent = 'Full name and ID are required.'; return; }
  const dup = getPatients().some((x,i)=> i!==ix && (x.pid||'').toLowerCase()===pid.toLowerCase());
  if(dup){ $('editMsg').textContent='ID already exists.'; return; }
  updatePatient(editingId, {
    fullname, pid,
    dob: $('edit_dob').value || '',
    sex: $('edit_sex').value || '',
    email: $('edit_email').value || '',
    phone: $('edit_phone').value || '',
    notes: $('edit_notes').value || '',
    updated_at: Date.now()
  });
  renderList(); closeEditor();
}

function onAdd(){
  const fullname = $('new_fullname').value.trim();
  const pid      = $('new_pid').value.trim();
  if(!fullname || !pid){ $('addMsg').textContent = 'Full name and ID are required.'; return; }
  const dup = getPatients().some(p => (p.pid||'').toLowerCase()===pid.toLowerCase());
  if(dup){ $('addMsg').textContent='ID already exists.'; return; }
  addPatient({
    uid: uid(),
    fullname, pid,
    dob: $('new_dob').value || '',
    sex: $('new_sex').value || '',
    email: $('new_email').value || '',
    phone: $('new_phone').value || '',
    notes: $('new_notes').value || '',
    created_at: Date.now()
  });
  renderList(); clearNewForm();
  $('addMsg').textContent = 'Patient added.'; setTimeout(()=>$('addMsg').textContent='', 1200);
}

export function initRegister(){
  if ($('btnAdd')?.dataset.bound) return; // evita bind duplo
  $('btnAdd')?.addEventListener('click', onAdd);
  $('btnAdd') && ($('btnAdd').dataset.bound = '1');
  $('search')?.addEventListener('input', renderList);
  document.getElementById('ptTable')?.addEventListener('click', (e)=>{
    const btn = e.target.closest('button'); if(!btn) return;
    const id = btn.dataset.id;
    if(btn.dataset.act==='edit') openEditor(id);
    else if(btn.dataset.act==='del') deletePatient(id), renderList(), closeEditor();
  });
  $('btnSave')?.addEventListener('click', saveEditor);
  $('btnCancel')?.addEventListener('click', closeEditor);

  // re-render quando a store mudar (ex.: Live adicionar algo no futuro)
  store.subscribe(renderList);
  renderList();
}
