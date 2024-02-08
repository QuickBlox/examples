// const { contextBridge, ipcRenderer } = require('electron');
//
// contextBridge.exposeInMainWorld('electronAPI', {
//     requestData: () => {
//         return new Promise((resolve, reject) => {
//             ipcRenderer.send('request-data');
//             ipcRenderer.once('response-data', (event, data) => {
//                 resolve(data);
//             });
//             ipcRenderer.once('response-error', (event, error) => {
//                 reject(error);
//             });
//         });
//     }
// });

const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
    requestData: async () => {
        return new Promise((resolve, reject) => {
            ipcRenderer.send('request-data');
            ipcRenderer.once('response-data', (event, data) => {
                resolve(data);
            });
            ipcRenderer.once('response-error', (event, error) => {
                reject(error);
            });
        });
    }
});
