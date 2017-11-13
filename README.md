# TripleO Utils

These are my personal utilities and so on for doing development with TripleO.

You are welcome to use them, at your own risk ;-)

## Usage

1. Clone the repo and move into the directory.

```
git clone https://github.com/d0ugal/tripleo-util.git && cd tripleo-util
```

2. Copy your openrc.sh into the directory.

3. Build and start the container.

```
./start.sh
```

4. Start quickstart from within the container.

```
./run.sh
```

5. Once it completes. Connect to the undercloud.

```
./ssh.sh
```

## Useful tibits

- Each quickstart output will be logged to ./logs
- ./scripts contains some useful things to run on the undercloud, you need to
  copy them up for now, but that should be automated at some point.
