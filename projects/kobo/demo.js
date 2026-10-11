'use strict';
(async function(){
 const $=id=>document.getElementById(id), el=(tag,text,cls)=>{const n=document.createElement(tag);if(text)n.textContent=text;if(cls)n.className=cls;return n;};
 let data,mode='spot',values={},records=[],reviewed=false;
 try{const res=await fetch('data.json');if(!res.ok)throw Error('Form unavailable');data=await res.json();}catch(e){$('load-error').hidden=false;$('load-error').textContent='Could not load forms. Please reload the page.';$('progress').textContent='Form unavailable';return;}
 const evaluate=(s,current='')=>KoboLogic.rule(s,values,current,data.schools);
 function derive(){const school=data.schools[values.village_code];for(const r of data.forms[mode].survey.filter(r=>r.type==='calculate'))values[r.name]=school?.[r.name]||'';values.school=school?values.village_code:'';}
 function refresh(check=false){derive();let answered=0,total=0,errors=[];
  for(const r of records){r.visible=(!r.parent||r.parent.visible)&&evaluate(r.source.relevant);r.node.hidden=!r.visible;for(const c of r.controls)c.disabled=!r.visible;
   if(r.source.type==='note')r.node.textContent=r.source['label::Hindi'].replace(/\$\{([^}]+)\}/g,(_,key)=>values[key]||'—');
   if(!r.input)continue;let message='';const value=values[r.source.name]||'';
   if(r.visible){total++;if(value!=='')answered++;if((check||reviewed)&&r.source.required==='yes'&&value==='')message='यह उत्तर आवश्यक है।';else if(value!==''&&!evaluate(r.source.constraint,value))message=r.source['constraint_message::Hindi']||'कृपया सही मान भरें।';}
   r.error.textContent=message;for(const c of r.controls)c.setAttribute('aria-invalid',String(Boolean(message)));if(message)errors.push(r);
  }
  $('progress').textContent=`${mode==='spot'?'Spot Check':'Cross-check'} · ${answered}/${total} visible fields answered`;return errors;
 }
 function build(){values={visit_date:new Date().toISOString().slice(0,10),observer:'Demo Observer'};records=[];reviewed=false;$('feedback').textContent='';$('questionnaire').replaceChildren();const stack=[];
  for(const source of data.forms[mode].survey){const type=source.type;if(type==='end_group'){stack.pop();continue;}if(['start','end','calculate'].includes(type)||source.name==='school')continue;
   const parent=stack.at(-1),group=type==='begin_group',multiple=type.startsWith('select_multiple'),note=type==='note';
   const node=el(group||multiple?'fieldset':'div',null,group?'group':'field');const r={source,node,parent,controls:[],visible:true};records.push(r);(parent?parent.node:$('questionnaire')).append(node);
   if(group){node.append(el('legend',source['label::Hindi']));stack.push(r);continue;}if(note){node.className=source.name==='school_details'?'auto-details':'invalid-note';continue;}
   const id='answer-'+source.name,label=el(multiple?'legend':'label',source['label::Hindi'],'question-title');if(!multiple)label.htmlFor=id;if(source.required==='yes')label.append(el('span',' *','required'));node.append(label);
   const hint=el('p',source['hint::Hindi']||'','hint');hint.id=id+'-hint';if(hint.textContent)node.append(hint);r.error=el('p','','error');r.error.id=id+'-error';
   const options=data.forms[mode].choices[type.split(' ')[1]]||[];
   if(multiple){for(const option of options){const wrap=el('label',null,'option'),c=el('input');c.type='checkbox';c.value=option.name;c.id=id+'-'+option.name;wrap.append(c,document.createTextNode(option.label));node.append(wrap);r.controls.push(c);}}
   else{let c;if(type.startsWith('select_one')){c=el('select');c.append(new Option('उत्तर चुनें…',''));for(const option of options)c.append(new Option(option.label,option.name));}else{c=el(type==='text'&&!['village_code','observer'].includes(source.name)?'textarea':'input');if(c.tagName==='INPUT')c.type=type==='integer'?'number':type==='date'?'date':'text';if(type==='integer')c.step='1';if(source.name==='village_code'){c.inputMode='numeric';c.maxLength=9;c.placeholder='900000001';}}
    c.id=id;c.value=values[source.name]||'';node.append(c);r.controls.push(c);}
   r.input=true;for(const c of r.controls){c.setAttribute('aria-describedby',hint.id+' '+r.error.id);if(source.required==='yes')c.setAttribute('aria-required','true');c.addEventListener('input',()=>{values[source.name]=multiple?r.controls.filter(x=>x.checked).map(x=>x.value).join(' '):c.value;refresh();$('feedback').textContent='';});}node.append(r.error);
  }
  for(const m of ['spot','cross'])$(m).setAttribute('aria-pressed',String(m===mode));refresh();
 }
 for(const m of ['spot','cross'])$(m).addEventListener('click',()=>{mode=m;build();});
 for(const b of document.querySelectorAll('[data-code]'))b.addEventListener('click',()=>{values.village_code=b.dataset.code;$('answer-village_code').value=b.dataset.code;refresh();});
 $('reset').addEventListener('click',build);$('questionnaire').addEventListener('submit',e=>e.preventDefault());
 $('review').addEventListener('click',()=>{reviewed=true;const errors=refresh(true);$('feedback').textContent=errors.length?`${errors.length} visible fields need attention.`:'All visible answers pass local checks. This demo does not submit responses.';if(errors.length)errors[0].controls[0].focus();});
 $('export').addEventListener('click',()=>{const errors=refresh(true),answers={};for(const r of records)if(r.visible&&r.input)answers[r.source.name]=values[r.source.name]||'';const payload={demo:true,synthetic_school_data:true,form:mode,validation_complete:errors.length===0,school:data.schools[values.village_code]||null,answers};const url=URL.createObjectURL(new Blob([JSON.stringify(payload,null,2)],{type:'application/json'})),a=el('a');a.href=url;a.download=`bal-sabha-lse-${mode}-demo.json`;a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);$('feedback').textContent=errors.length?'Partial demo downloaded. Some visible answers need attention.':'Validated demo responses downloaded.';});
 build();
})();
