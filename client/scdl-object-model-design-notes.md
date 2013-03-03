# SCDL Object Model Notes

This is a terse overview of the Soft Circuit Description Language (SCDL) object model. 

## Types

SCDL type models are simple JSON objects that abstractly describe some unique data type.

Key to understanding SCDL, is wrapping your head around the SCDL type system.

SCDL type models are essentially monikers - labels if you will that *imply* that somewhere, somehow, it's
possible to send or receive a specific value in a specific format. That's it.

Explicitly, SCDL types are decoupled from details of how a value of a type is represented in memory, on disk,
on the wire...

To understand this consider a populated circuit board (PCB). The motherboard in your computer for example.
Your motherboard is a system. It has inputs and outputs. It has state. Lots of it although it's actually
so complex that no human being on earth can actually understand it except in terms of small chunks and
composition rules. But I digress.

Soldered or socketed to your motherboard are hundreds of integrated circuit chips. Each does something
specific. The chips "talk to each" that is communicate by sending digital signals through wires embeded
on the surface and in embedded layers of the circuit board.

There are some basic rules about how digital circuits work that carry over into SCDL. Specifically the
notion of an input or output __pin__ is adopted from integrated circuits. Pins represent an instance,
or concrete value, of a type. Relating this back to IC's, a hypothetical IC might have an input pin
labeled "Bus Select".

In this example "Bus Select" is the *type*. This is an intentionally simple example: it's easy to
imagine that "Bus Select" is simply a boolean input that will be understood to be "one" if the voltage
on the wire connected to the input pin exceeds 4.8V (or whatever - it doesn't matter).

Still there? Okay, let's turn this back towards software. In our hypothetical IC example above,
we imagined a simple input labeled "Bus Select". How would we model this in software?

It's actually not that difficult. A pin is a boolean by definition. Pins are connected to each other by wires.
One pin (an output pin) drives the voltage on the node to "one" or down to "zero" and input pins connected
to the same node in the circuit monitor this voltage.







## Interconnections

### Pins

### Signals

### Channels

### Buses

### Trunks

## Extensibility

### Sockets

### Contracts

## Processing

### Machines

#### Machine I/O

#### Machine States

#### Machine Transitions

#### Computing Model

## Re-use

### Modules

#### Module I/O

#### Module Architecture

##### Contained Entities

##### Internal Interconnect Topology

## Composability

### Systems







