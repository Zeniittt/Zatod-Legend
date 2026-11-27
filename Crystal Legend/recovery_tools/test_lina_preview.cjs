const { chromium } = require('C:/Program Files/WindowsApps/OpenAI.CodexPrimaryRuntime.v26-1117-1425-0_26.1117.1425.0_x64__3k8sg7r9htsxt/dependencies/node/node_modules/playwright');
const fs = require('node:fs/promises');
const path = require('node:path');
const root = path.resolve(__dirname, '..');

(async () => {
  const browser = await chromium.launch({headless:true, executablePath:path.join(root,'.recovery-deps/browsers/chromium_headless_shell-1234/chrome-headless-shell-win64/chrome-headless-shell.exe')});
  try {
    const page = await browser.newPage({viewport:{width:1000,height:850}});
    const errors=[];
    page.on('pageerror',e=>errors.push(e.message));
    await page.goto('file:///'+root.replaceAll('\\','/')+'/recovered/lina_preview/preview.html');
    const frame = page.frames().find(f=>f!==page.mainFrame());
    await frame.waitForSelector('#lina-animation-sketch[data-ready="true"]',{timeout:10000});
    console.log('Ready');
    console.log(await frame.evaluate(()=>({state:document.getElementById('lina-animation-sketch').preview.getState(),button:document.getElementById('lina-play').outerHTML})));
    const select = frame.locator('#lina-action');
    await select.selectOption('attack');
    console.log('Selected attack');
    await frame.evaluate(()=>{window.__previewAudios=[];const NativeAudio=window.Audio;
      window.Audio=function(...args){const audio=new NativeAudio(...args);window.__previewAudios.push(audio);return audio;};});
    await frame.locator('#lina-sound').check({timeout:5000});
    await frame.locator('#lina-play').click({timeout:5000});
    console.log('Clicked play');
    await new Promise(resolve=>setTimeout(resolve,500));
    const playback = await frame.evaluate(()=>document.getElementById('lina-animation-sketch').preview.getState());
    console.log('Playback state',playback);
    if(!playback.playing || playback.time<.2)throw Error('Playback did not advance');
    const audioCheck=await frame.evaluate(()=>window.__previewAudios.map(a=>({time:a.currentTime,ready:a.readyState,error:a.error?.message||null})));
    if(!audioCheck.length || audioCheck.some(a=>a.error) || !audioCheck.some(a=>a.time>0))throw Error('Sound playback failed: '+JSON.stringify(audioCheck));
    console.log('Audio playback',audioCheck);
    await frame.locator('#lina-play').click({timeout:5000});
    await frame.locator('#lina-time').evaluate(el=>{el.value=.8;el.dispatchEvent(new Event('input',{bubbles:true}));});
    const scrub=await frame.evaluate(()=>document.getElementById('lina-animation-sketch').preview.getState());
    if(Math.abs(scrub.time-.8)>.006 || scrub.playing)throw Error('Timeline scrub failed');
    const checks=[];
    for(const [key,time] of [['attack',.8],['wave',.8],['stun',1.2],['ult',1.62],['Idle',.5],['Move',.5],['Damaged',.3],['Cheer',.5],['Death',.5],['passive',.8]]){
      await select.selectOption(key);
      await frame.locator('#lina-animation-sketch').evaluate((el,t)=>el.preview.seek(t),time);
      checks.push(await frame.evaluate(()=>document.getElementById('lina-animation-sketch').preview.getState()));
      if(['attack','wave','stun','ult'].includes(key))await frame.locator('#lina-stage').screenshot({path:path.join(root,'recovered/lina_preview/qa',key+'.png')});
    }
    const layouts=[];
    for(const width of [736,320]){
      await page.setViewportSize({width,height:850});
      layouts.push(await frame.locator('#lina-animation-sketch').evaluate(el=>({width:el.clientWidth,scrollWidth:el.scrollWidth,canvasWidth:el.querySelector('canvas').getBoundingClientRect().width})));
      await page.screenshot({path:path.join(root,'recovered/lina_preview/qa','layout-'+width+'.png')});
    }
    if(layouts.some(l=>l.scrollWidth>l.width+1))throw Error('Responsive layout overflows');
    if(errors.length)throw Error(errors.join('\n'));
    await fs.writeFile(path.join(root,'recovered/lina_preview/qa/verification.json'),JSON.stringify({playback,audioCheck,checks,layouts,errors},null,2));
    console.log('All visual interactions passed',JSON.stringify({layouts,errors}));
  } finally { await browser.close(); }
})().catch(e=>{console.error(e);process.exitCode=1;});
