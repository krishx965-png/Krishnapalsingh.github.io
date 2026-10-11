(function(root){
'use strict';
function rule(expression,values={},current='',schools={}){
 if(!expression)return true;
 const exp=expression.replace(/count\(instance\('school_master'\)\/root\/item\[name = \$\{village_code\}\]\)/g,schools[values.village_code]?'1':'0');
 const tokens=[];const pattern=/\s*(\$\{[A-Za-z0-9_]+\}|>=|<=|!=|=|>|<|\(|\)|,|\.|\d+(?:\.\d+)?|'[^']*'|[a-z-]+)\s*/gy;let pos=0;
 while(pos<exp.length){pattern.lastIndex=pos;const m=pattern.exec(exp);if(!m)throw Error('Unsupported form rule at '+exp.slice(pos));tokens.push(m[1]);pos=pattern.lastIndex;}
 let at=0;const peek=()=>tokens[at];const take=()=>tokens[at++];const want=t=>{if(take()!==t)throw Error('Expected '+t)};
 function primary(){const t=take();if(t===undefined)throw Error('Missing rule value');if(t==='('){const v=or();want(')');return v;}if(t.startsWith('${'))return values[t.slice(2,-1)]??'';if(t==='.'){return current;}if(t.startsWith("'"))return t.slice(1,-1);if(/^\d/.test(t))return Number(t);
  if(peek()==='('){take();const args=[];if(peek()!==')'){args.push(or());while(peek()===','){take();args.push(or());}}want(')');switch(t){case 'not':return !args[0];case 'selected':return String(args[0]).split(/\s+/).includes(String(args[1]));case 'count-selected':return String(args[0]).trim()?String(args[0]).trim().split(/\s+/).length:0;case 'regex':return new RegExp(String(args[1])).test(String(args[0]));case 'true':return true;case 'false':return false;default:throw Error('Unsupported function '+t);}}
  throw Error('Unsupported token '+t);
 }
 function compare(){let a=primary();if(['=','!=','>','<','>=','<='].includes(peek())){const op=take();let b=primary();if(typeof a==='number'||typeof b==='number'){a=a===''?NaN:Number(a);b=b===''?NaN:Number(b);}switch(op){case '=':return a===b;case '!=':return a!==b;case '>':return a>b;case '<':return a<b;case '>=':return a>=b;case '<=':return a<=b;}}return a;}
 function and(){let v=compare();while(peek()==='and'){take();const b=compare();v=Boolean(v)&&Boolean(b);}return v;}
 function or(){let v=and();while(peek()==='or'){take();const b=and();v=Boolean(v)||Boolean(b);}return v;}
 const value=or();if(at!==tokens.length)throw Error('Unexpected rule tokens');return Boolean(value);
}
if(typeof module!=='undefined'&&module.exports)module.exports={rule};else root.KoboLogic={rule};
})(typeof globalThis==='undefined'?this:globalThis);
