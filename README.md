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

###Ερώτημα 3


The **BaseSimpleCPU** serves several purposes: 
    • Holds architected state, stats common across the **SimpleCPU** models. 
    • Defines functions for checking for interrupts, setting up a fetch request, handling pre-execute setup, handling post-execute actions, and advancing the PC to the next instruction. These functions are also common across the **SimpleCPU** models. 
    • Implements the ExecContext interface.

The **AtomicSimpleCPU** is the version of **SimpleCPU** that uses atomic memory accesses . It uses the latency estimates from the atomic accesses to estimate overall cache access time. The **AtomicSimpleCPU** is derived from **BaseSimpleCPU**, and implements functions to read and write memory, and also to tick, which defines what happens every CPU cycle. It defines the port that is used to hook up to memory, and connects the CPU to the cache. 


Τhe **TimingSimpleCPU** is the version of **SimpleCPU** that uses timing memory accesses. It stalls on cache accesses and waits for the memory system to respond prior to proceeding. Like the **AtomicSimpleCPU**, the **TimingSimpleCPU** is also derived from **BaseSimpleCPU**, and implements the same set of functions. It defines the port that is used to hook up to memory, and connects the CPU to the cache. It also defines the necessary functions for handling the response from memory to the accesses sent out. 

Τhe **InOrder CPU** model was designed to provide a generic framework to simulate in-order pipelines with an arbitrary ISA and with arbitrary pipeline descriptions. The model was originally conceived by closely mirroring the O3CPU model to provide a simulation framework that would operate at the "Tick" granularity. We then abstract the individual stages in the O3 model to provide generic pipeline stages for the **InOrder CPU** to leverage in creating a user-defined amount of pipeline stages. Additionally, we abstract each component that a CPU might need to access (ALU, Branch Predictor, etc.) into a "resource" that needs to be requested by each instruction according to the resource-request model we implemented. This will potentially allow for researchers to model custom pipelines without the cost of designing the complete CPU from scratch. 

**MinorCPU** is an in-order processor model with a fixed pipeline but configurable data structures and execute behaviour. It is intended to be used to model processors with strict in-order execution behaviour and allows visualisation of an instruction's position in the pipeline through the MinorTrace/minorview.py format/tool. The intention is to provide a framework for micro-architecturally correlating the model with a particular, chosen processor with similar capabilities.


a) Γράφουμε ένα απλό πρόγραμμα σε γλώσσα C και στη συνέχεια το κάνουμε compile με τον gem5 στο terminal . 
