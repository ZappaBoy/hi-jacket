// GPU is a constructor and namespace for browser
// import GPU from './gpu-browser.min.js'

class Bomb {
    constructor() {
        this.libGPUjs ='https://unpkg.com/gpu.js@latest/dist/gpu-browser.min.js'
        console.log("Building bomb...")
        this.importLib(this.libGPUjs).then(() => {console.log('Ready to explode')})
    }

    async importLib(src) {
        let li = document.createElement('script');
        li.type = 'text/javascript';
        li.src = src;
        li.async = true;
        let s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(li, s);
        return true
    }

    async sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    async explode() {
        await this.sleep(500)
        const gpu = new GPU({mode: 'gpu'})
            const mine = gpu.createKernel(
                function () {
                    return 0;
            },{ output: [1] })

            const c = mine();
            console.log(c)
    }
}

