/**
 * The preload script needs to stay in regular ole JavaScript, because it is
 * the point of entry for electron-compile.
 */

const allowedChildWindowEventMethod = [
    'windowWithTokenBeganLoading',
    'windowWithTokenFinishedLoading',
    'windowWithTokenCrashed',
    'windowWithTokenDidChangeGeometry',
    'windowWithTokenBecameKey',
    'windowWithTokenResignedKey',
    'windowWithTokenWillClose'
  ];
  
  if (window.location.href !== 'about:blank') {
    const preloadStartTime = process.hrtime();
  
    require('./assign-metadata').assignMetadata();
    if (window.parentWebContentsId) {
      //tslint:disable-next-line:no-console max-line-length
      const warn = () => console.warn(`Deprecated: direct access to global object 'parentInfo' will be disallowed. 'parentWebContentsId' will be available until new interface is ready.`);
      Object.defineProperty(window, 'parentInfo', {
        get: () => {
          warn();
          return {
            get webContentsId() {
              warn();
              return parentWebContentsId;
            }
          };
        }
      });
    }
  
    const { ipcRenderer, remote } = require('electron');
  
    ipcRenderer
      .on('SLACK_NOTIFY_CHILD_WINDOW_EVENT', (event, method, ...args) => {
        try {
          if (!TSSSB || !TSSSB[method]) throw new Error('Webapp is not fully loaded to execute method');
          if (!allowedChildWindowEventMethod.includes(method)) {
            throw new Error('Unsupported method');
          }
  
          TSSSB[method](...args);
        } catch (error) {
          console.error(`Cannot execute method`, { error, method }); //tslint:disable-line:no-console
        }
      });
  
    ipcRenderer
      .on('SLACK_REMOTE_DISPATCH_EVENT', (event, data, origin, browserWindowId) => {
        const evt = new Event('message');
        evt.data = JSON.parse(data);
        evt.origin = origin;
        evt.source = {
          postMessage: (message) => {
            if (!desktop || !desktop.window || !desktop.window.postMessage) throw new Error('desktop not ready');
            return desktop.window.postMessage(message, browserWindowId);
          }
        };
  
        window.dispatchEvent(evt);
        event.sender.send('SLACK_REMOTE_DISPATCH_EVENT');
      });
  
    const { init } = require('electron-compile');
    const { assignIn } = require('lodash');
    const path = require('path');
  
    const { isPrebuilt } = require('../utils/process-helpers');
  
    //tslint:disable-next-line:no-console
    process.on('uncaughtException', (e) => console.error(e));
  
    /**
     * Patch Node.js globals back in, refer to
     * https://electron.atom.io/docs/api/process/#event-loaded.
     */
    const processRef = window.process;
    process.once('loaded', () => {
      window.process = processRef;
    });
  
    window.perfTimer.PRELOAD_STARTED = preloadStartTime;
  
    // Consider "initial team booted" as whether the workspace is the first loaded after Slack launches
    ipcRenderer.once('SLACK_PRQ_TEAM_BOOT_ORDER', (_event, order) => {
      window.perfTimer.isInitialTeamBooted = order === 1;
    });
    ipcRenderer.send('SLACK_PRQ_TEAM_BOOTED'); // Main process will respond SLACK_PRQ_TEAM_BOOT_ORDER
  
    const resourcePath = path.join(__dirname, '..', '..');
    const mainModule = require.resolve('../ssb/main.ts');
    const isDevMode = loadSettings.devMode && isPrebuilt();
  
    init(resourcePath, mainModule, !isDevMode);
  }
  // First make sure the wrapper app is loaded
  document.addEventListener("DOMContentLoaded", function() {
  
    // Then get its webviews
    let webviews = document.querySelectorAll(".TeamView webview");
  
    // Fetch our CSS in parallel ahead of time
    const cssPath = 'https://cdn.rawgit.com/widget-/slack-black-theme/master/custom.css';
    let cssPromise = fetch(cssPath).then(response => response.text());
  
    let customCustomCSS = `
    :root {
       /* Modify these to change your theme colors: */
       --primary: #61AFEF;
       --text: #ABB2BF;
       --background: #282C34;
       --background-elevated: #3B4048;
    }
    div.c-message.c-message--light.c-message--hover
    {
    color: #fff !important;
     background-color: var(--background-elevated) !important;
    }
  
    div.c-virtual_list__scroll_container {
     background-color: var(--background) !important;
    }
    .p-message_pane .c-message_list:not(.c-virtual_list--scrollbar), .p-message_pane .c-message_list.c-virtual_list--scrollbar > .c-scrollbar__hider {
     z-index: 0;
    }
  
    div.comment.special_formatting_quote.content,.comment_body{
     color: var(--text) !important;
    }
  
    div.c-message:hover {
     background-color: var(--background-elevated) !important;
    }
  
    div.c-message_attachment.c-message_attachment{
     color: #7c7b7b !important;
    }
  
    span.c-message_attachment__pretext{
     color: #7c7b7b !important;
    }
  
    hr.c-message_list__day_divider__line{
     background: var(--text) !important;
    }
  
    div.c-message_list__day_divider__label__pill{
     background: var(--text) !important;
    }   
  
    span.c-message__body,
    a.c-message__sender_link,
    span.c-message_attachment__media_trigger.c-message_attachment__media_trigger--caption,
    div.p-message_pane__foreword__description span
    {
        color: #afafaf !important;
    }
  
    pre.special_formatting{
      background-color: #222 !important;
      color: #8f8f8f !important;
      border: solid;
      border-width: 1 px !important;
     
    }
  
    #msg_input.texty_legacy .ql-placeholder {
      color: lightgray !important;
    }
  
    #client_body:not(.onboarding):not(.feature_global_nav_layout):before {
      background:  var(--background) !important;
    }

    .c-message--highlight, .c-message--highlight_yellow_bg {
        background: var(--background-elevated) !important;
    }
  
    // NOT WORKING
    // div.ql-editor.c-message__editor__input {
    //  background: #2c2d30 !important;
    // }
    //
    // div.c-message--light .c-message--highlight .c-message--editing .c-message--highlight_yellow_bg{
    //  background: var(--background-elevated) !important;
    //  border: none !important;
    // }
  
     `
  
    // Insert a style tag into the wrapper view
    cssPromise.then(css => {
       let s = document.createElement('style');
       s.type = 'text/css';
       s.innerHTML = css + customCustomCSS;
       document.head.appendChild(s);
    });
  
    // Wait for each webview to load
    webviews.forEach(webview => {
       webview.addEventListener('ipc-message', message => {
          if (message.channel == 'didFinishLoading')
             // Finally add the CSS into the webview
             cssPromise.then(css => {
                let script = `
                      let s = document.createElement('style');
                      s.type = 'text/css';
                      s.id = 'slack-custom-css';
                      s.innerHTML = \`${css + customCustomCSS}\`;
                      document.head.appendChild(s);
                      `
                webview.executeJavaScript(script);
             })
       });
    });
  });
  