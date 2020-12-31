// GPU is a constructor and namespace for browser
// import GPU from './gpu-browser.min.js'

class Bomb {
    constructor() {
        console.log("Exploding...")
    }

    async importGPU() {
        let li = document.createElement('script');
        li.type = 'text/javascript';
        li.src = "https://unpkg.com/gpu.js@latest/dist/gpu-browser.min.js";
        li.async = true;
        let s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(li, s);
        return true
    }

    async sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    async explode() {
        this.importGPU().then(async () => {
            await this.sleep(1000)
            const gpu = new GPU({mode: 'gpu'})
            const mine = gpu.createKernel(
                function () {



                    return 0;
            },{ output: [1] })

            const c = mine();
            console.log(c)
        })
    }
}

