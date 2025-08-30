import { startECG } from './ecg.js';

let started = false;
export function initAbout(){
  if (started) return; started = true;
  const mini = document.getElementById('miniECG');
  if (mini) startECG(mini, 2, 3);
}
