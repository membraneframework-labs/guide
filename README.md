# Introduction

This file file serves as your book's preface, a great place to describe your book's content and ideas.

## Goals

### Technical

Membrane Framework was created in order to allow creating reliable and stable multimedia processing applications. As creators of many high-availability applications we have been disappointed by numerous design or implementation flaws present in many other frameworks we've been using. We have found them to be either unstable, too low-level, too high-level, low quality, requiring us to code in C which does not scale in real-life projects, or based on improper foundations \(such as JVM or GLib\).

We decided to make a framework that puts **reliability and scalability over all other things** such as performance, low latency or efficent memory use. It does not mean that we don't care about the latter aspects, but if we have to make a tradeoff it is going to be made in favor of reliability and scalability.

It's API is heavily inspired by GStreamer's and here we pay tribute to all outstanding work made by its developers. Sometimes you need to write an application where you don't care if you spend 10 or 20 milliseconds on processing but you need to make it working 24/7 and then Membrane Framework is the right choice. If you need to squeeze each CPU cycle from your computer probably there are better solutions available.

Moreover, we do not aim at making framework that handles all formats and tools ever invented. We prefer to maintain smaller set of modules but with higher quality.

### Business

Membrane Framework in general is an open-source project, but we're aware that some businesses need additional long-term support, availability of some of the key developers or implementing custom features or elements. This is why we're establishing Enterprise Edition of the Membrane Framework from the day one. The core and the most universal components of the framework will remain open for the whole community.

## Design

### Language

We have chosen Elixir as a language as underlying Erlang/OTP allows us to easily write highly concurrent, soft-realtime, reliable applications. BEAM - the Erlang's Virtual Machine is a wonderful piece of software that handles for us many hard topics related to concurrency and reliability. One of it's great benefits that was reason to use Elixir instead of Go that was also taken under consideration is that its garbage collector works per-process \(where process is an Erlang process, not the system one\) which prevents hiccups from happening if application is getting large. Elixir itself allows us to write code using sane syntax with high degree of efficency.

We refer to C libraries only when absolutely necessary or it makes no sense to rewrite complicated piece of code from scratch.

Currently they run as NIFs \(native code embedded in the VM, faster but can crash the VM\) but in the future releases we're planning to allow developer to decide whether he/she wants to run them as NIFs or run them as ports \(separate processes launched by the VM, slower but safer\) for increased reliability. Some components might always need to rely on NIFs due to technical limitations but wherever it's possible we're going to allow to detach the unsafe, crash-prone C code from the application's process so even if e.g. one of your encoders crashes the whole application will keep running.

### API

The API is similar to one of GStreamer so if you are user of GStreamer, you will quickly find yourself familiar with it.

For these who are not familiar with GStreamer:

TODO

