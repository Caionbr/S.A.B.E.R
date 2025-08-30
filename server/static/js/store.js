const KEY = 'saber_patients_v2';
let patients = [];
const listeners = new Set();

function load() {
  try { patients = JSON.parse(localStorage.getItem(KEY) || '[]'); }
  catch { patients = []; }
}
function save() { localStorage.setItem(KEY, JSON.stringify(patients)); }

export function getPatients() { return patients.slice(); }
export function addPatient(p) { patients.push(p); save(); notify(); }
export function updatePatient(uid, patch) {
  const i = patients.findIndex(x=>x.uid===uid); if(i<0) return;
  patients[i] = { ...patients[i], ...patch }; save(); notify();
}
export function deletePatient(uid) {
  patients = patients.filter(x=>x.uid!==uid); save(); notify();
}
export function subscribe(fn){ listeners.add(fn); return ()=>listeners.delete(fn); }
function notify(){ listeners.forEach(fn=>fn(getPatients())); }

load();
export const store = { getPatients, addPatient, updatePatient, deletePatient, subscribe };
