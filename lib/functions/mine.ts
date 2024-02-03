import { default as fs } from 'fs-extra'
import { exec, execSync } from "child_process";
import dedent from 'dedent';

import { mineContracts } from '../constants';

const efficientAddressesPath = "create2crunch/efficient_addresses.txt"

let crunchSeconds = 15;
let crunchLeading = 5;
let crunchTotal = 7;
let crunchAddresses = 10;
let factoryAddress = "0x0000000000ffe8b47b3e2130213b802212439497"
let callerAddress = "0x0000000000000000000000000000000000000000"
let quick = false;
let force = false;
let install = false;
let match = ""

const args = process.argv.slice(2); // Remove the first two elements (tsx lib/functions/mine.ts)
args.forEach(arg => {
    const [key, value] = arg.split('=');
    switch (key) {
        case '--seconds':
            crunchSeconds = parseInt(value, 10);
            break;
        case '--leading':
            crunchLeading = parseInt(value, 10);
            break;
        case '--total':
            crunchTotal = parseInt(value, 10);
            break;
        case '--addresses':
            crunchAddresses = parseInt(value, 10);
            break;
        case '--factory':
            factoryAddress = value;
            break;
        case '--caller':
            callerAddress = value;
            break;
        case '--quick':
            quick = true;
            break;
        case '--match':
            match = value;
            break;
        case '--force':
            force = true;
            break;
        case '--install':
            install = true;
            break;
    }
});

const addressesJson = fs.readFileSync("lib/addresses.json");
const addresses = JSON.parse(addressesJson.toString());

execSync(`rm -rf create2crunch`);

if (install)
    execSync(`sudo apt install build-essential -y; curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; source "$HOME/.cargo/env";`)

execSync(`git clone https://github.com/0age/create2crunch && cd create2crunch; sed -i -e 's/0x4/0x40/g' src/lib.rs`);

const efficientAddressesObject: Record<string, {
    initCodeHash: string,
    results: Array<Array<string>>
}> = {}

const timeStarted = new Date().toISOString();

const mine = async (contract: string): Promise<void> => {
    return new Promise((resolve, reject) => {
        if (!force && addresses[contract]) {
            console.log(`⏹︎ Skipping ${contract} as it already exists in the addresses.json file.`);
            console.log(`    ⏹︎ Use --force to overwrite.`);
            return resolve();
        }

        console.log(dedent`
            ⏹︎ Generating efficient address:
                Contract Name: ${contract}
                Seconds: ${crunchSeconds}
                Leading: ${crunchLeading}
                Total: ${crunchTotal}
                Quick: ${quick}
        `);

        const artifactPath = `artifacts/${contract}/`
        const contractName = contract.replaceAll(".sol", "").replaceAll(".", "");
        const initCodePath = `${artifactPath}${contractName}.initcode.json`
        const initCodeJson = JSON.parse(fs.readFileSync(initCodePath).toString());
        const initCodeHash = initCodeJson["initcodeHash"];

        const interval = setInterval(() => {
            const efficientAddressesExists = fs.existsSync(efficientAddressesPath);

            if (!efficientAddressesExists) {
                console.log("⏹︎ Efficient addresses file does not exist yet.");
                return
            }

            const efficientAddresses = fs.readFileSync(efficientAddressesPath).toString();
            let running = false

            if (efficientAddresses == "") running = true
            else if (quick == false && efficientAddresses.split("\n").length < crunchAddresses) running = true

            if (running) {
                console.log(`⏹︎ Waiting another ${crunchSeconds} second period.`);
                return
            }

            process.kill();
            clearInterval(interval);

            let results = efficientAddresses
                .split("\n")
                .map((address: string) => address.split(" => "))
                .sort((a: Array<string>, b: Array<string>) => parseInt(a[1]) - parseInt(b[1]));

            efficientAddressesObject[contract] = {
                initCodeHash: initCodeHash,
                results: results
            }
            fs.writeFileSync(efficientAddressesPath, "");

            resolve();
        }, crunchSeconds * 1000);

        const process = exec(`cd create2crunch && export FACTORY="${factoryAddress}"; export CALLER="${callerAddress}"; export INIT_CODE_HASH="${initCodeHash}"; export LEADING=${crunchLeading}; export TOTAL=${crunchTotal}; cargo run --release $FACTORY $CALLER $INIT_CODE_HASH 0 $LEADING $TOTAL`, function(error, stdout, stderr) {
            if (error) {
                console.error(`exec error: ${error}`);
                return reject(error);
            }
            console.log(`stdout: ${stdout}`);
            console.error(`stderr: ${stderr}`);
        });
    })
}

async function processContracts() {
    let found = false;

    for (const contract of mineContracts) {
        if (match != "" && !contract.includes(match)) {
            continue;
        }

        found = true;

        await mine(contract);
    }

    if (!found) {
        console.log(`⏹︎ No contracts found with match: ${match}`);
    }
}

processContracts().then(() => {
    const timeEnded = new Date().toISOString();
    const duration = (new Date(timeEnded).getTime() - new Date(timeStarted).getTime()) / 1000;

    console.log(`✔︎ All contract addresses mined in ${duration} seconds.`);

    if (!fs.existsSync("lib/addresses.json")) {
        fs.writeFileSync("lib/addresses.json", "{}");
    }

    // Loop through each key of the efficientAddressesObject and add the results to the 
    // JSON if we do not already have it or the initCodeHash is different
    for (const key in efficientAddressesObject) {
        const efficientAddresses = {
            ...efficientAddressesObject[key],
            results: efficientAddressesObject[key].results.filter((address: Array<string>) => address[0] != "")
        }
        const existingAddresses = addresses[key];

        if (!force && existingAddresses && existingAddresses.initCodeHash == efficientAddresses.initCodeHash) {
            continue
        }

        addresses[key] = efficientAddresses;
    }

    fs.writeFileSync("lib/addresses.json", JSON.stringify(addresses, null, 2));

    process.exit(0);
}).catch((error) => {
    console.error("An error occurred:", error);
    process.exit(1);
});
