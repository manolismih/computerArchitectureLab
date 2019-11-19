# computerArchitectureLab
_Reports from the lab assignments, for the Computer Architecure course, school of Electrical and Computer Enginneering, AUTH_
## Εργαστήριο 1: Εξοικείωση με τον προσομοιωτή gem5
_Η εργασία αυτή ζητάει την εγκατατάσταση του προσομειωτή **gem5**, την συλλογή πληροφοριών από την εκτέλεση του παραδείγματος **starter_se** και ενός δικού μας απλού προγράμματος γραμμένο σε C._
### Ερώτημα 1:
Ήδη από τον τρόπο εκτέλεσης και το αποτέλεσμα του παραδείγματατος λαμβάνουμε σημαντικές πληροφορίες: Η μοναδική παράμετρος που δηλώνουμε είναι η `--cpu-"minor"`
```sh
$ /build/ARM/gem5.opt configs/example/arm/starter_se.py --cpu="minor" "tests/test-progs/hello/bin/arm/linux/hello" 
```
Η εκτέλεση παράγει την έξοδο: 
```
Global frequency set at 1000000000000 ticks per second
```
που σημαίνει συχνότητα 1GHz. Ανοίγοντας το αρχείο `starter_se.py` παρατηρούμε ότι κάποια στοιχεία της κλάσης `SimpleSeSystem` γίνονται override:
```python
[σειρά 88]  cache_line_size = 64
[99]        self.voltage_domain = VoltageDomain(voltage="3.3V")
[100]       self.clk_domain = SrcClockDomain(clock="1GHz", voltage_domain=self.voltage_domain)
[121]       if self.cpu_cluster.memoryMode() == "timing":
[122]           self.cpu_cluster.addL1()
[123]           self.cpu_cluster.addL2(self.cpu_cluster.clk_domain)
```
Επομένως έχουμε δύο επίπεδα cache ενώ τα εξής σχόλια μας βοηθούν να καταλάβουμε τον τρόπο οργάνωσης των κρυφών μνημών για αυτήν την προσομοίωση:
```python
# Add CPUs to the system. A cluster of CPUs typically have
# private L1 caches and a shared L2 cache.
```
Τέλος, εφόσον δεν έχουμε ορίσει άλλες επιλογές από την γραμμή εντολών, θα ισχύσουν οι προεπιλογές που βρίσκονται στο τέλος του αρχείου `starter_se.py`:
```python
    parser.add_argument("--num-cores", type=int, default=1,
                        help="Number of CPU cores")
    parser.add_argument("--mem-type", default="DDR3_1600_8x8",
                        choices=ObjectList.mem_list.get_names(),
                        help = "type of memory to use")
    parser.add_argument("--mem-channels", type=int, default=2,
                        help = "number of memory channels")
    parser.add_argument("--mem-ranks", type=int, default=None,
                        help = "number of memory ranks per channel")
    parser.add_argument("--mem-size", action="store", type=str,
                        default="2GB",
                        help="Specify the physical memory size")
```
### Ερώτημα 2: 
Τα αρχεία `config.ini` και `config.json` περιέχουν τις ίδιες πληροφορίες με διαφορετική μορφή. Στο `config.ini`, στο πεδίο `[system]` μπορούμε να επαληθεύσουμε κατευθείαν ότι:
```ini
cache_line_size=64
mem_ranges=0:2147483647
memories=system.mem_ctrls0 system.mem_ctrls1
```

Ακολουθούμε τα πεδία που μας ενδιαφέρουν για να εξάγουμε τις πληροφορίες που ψάχνουμε:
```ini
[system.clk_domain]
clock=1000
#...
[system.cpu_cluster.cpus]
type=MinorCPU
numThreads=1
#...
[system.mem_ctrls0]
type=DRAMCtrl
device_bus_width=8
devices_per_rank=8
#...
[system.voltage_domain]
voltage=3.3
```
