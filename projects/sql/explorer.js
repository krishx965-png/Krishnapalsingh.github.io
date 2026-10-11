'use strict';
(async function(){
 const $=id=>document.getElementById(id);let data;
 try{const r=await fetch('results.json');if(!r.ok)throw Error('Results unavailable');data=await r.json();if(!data.synthetic)throw Error('Public demo must use synthetic data');}
 catch(e){$('error').hidden=false;$('error').textContent='Could not load demo results. Reload the page or download the SQL scripts.';$('query').disabled=true;$('copy').disabled=true;return;}
 data.queries.forEach(q=>{const option=document.createElement('option');option.value=q.id;option.textContent=q.id+' · '+q.title;$('query').append(option);});$('query').value=data.queries[0].id;
 function selected(){return data.queries.find(q=>q.id===$('query').value);}
 function render(){const q=selected();$('sql').textContent=q.sql;$('query-note').textContent=q.note;$('feedback').textContent='';$('result-count').textContent=q.rows.length+' result rows · synthetic data · recorded SQLite execution';const table=document.createElement('table'),head=document.createElement('thead'),tr=document.createElement('tr');q.columns.forEach(c=>{const cell=document.createElement('th');cell.scope='col';cell.textContent=c;tr.append(cell);});head.append(tr);table.append(head);const body=document.createElement('tbody');q.rows.forEach(r=>{const row=document.createElement('tr');q.columns.forEach(c=>{const cell=document.createElement('td');cell.textContent=r[c]===null?'NULL':String(r[c]);row.append(cell);});body.append(row);});table.append(body);$('result').replaceChildren(table);if(!q.rows.length){const p=document.createElement('p');p.textContent='No rows returned.';$('result').append(p);}}
 $('query').addEventListener('change',render);$('copy').addEventListener('click',async()=>{try{await navigator.clipboard.writeText(selected().sql);$('feedback').textContent='Query copied.';}catch(e){$('feedback').textContent='Select the SQL text and copy it manually.';}});render();
})();
