# RF System Identification with MATLAB

MATLAB project for RF system identification and signal-response analysis across multiple signal classes and carrier-frequency configurations.

This portfolio version keeps the MATLAB source files and excludes raw measurement datasets to keep the repository lightweight.

---

## Project overview

The original project is organized around RF measurements collected under different input excitations and frequency configurations.

The local experimental structure includes signal classes such as:

- Handel audio signal;
- white noise;
- null input signal;
- sweep signal;
- sinusoidal inputs at different baseband frequencies.

Each signal class is organized across multiple RF configurations:

```text
25MHz, 35MHz, 45MHz, 55MHz, 65MHz, 75MHz, 85MHz, 95MHz
```

The goal is to analyze and model how the RF system responds to different input conditions.

---

## Engineering objective

The system-identification task can be interpreted as learning or estimating the mapping:

```math
\hat{y}(t) = f_\theta(x(t))
```

where:

- `x(t)` is the excitation signal or extracted feature vector;
- `y(t)` is the measured RF response;
- `f_\theta` is the identified model;
- `\hat{y}(t)` is the predicted system output.

The project explores MATLAB-based preprocessing, validation and neural-network/system-identification workflows.

---

## Repository structure

```text
rf-system-identification-rs-monitor/
├── src/
│   └── matlab/
├── README.md
└── .gitignore
```

---

## Dataset policy

Raw experimental datasets are not tracked in this repository.

They are excluded because measurement folders can be large, hardware-specific and not always suitable for public distribution. The repository focuses on MATLAB source code and project methodology.

---

## Technical focus

This project demonstrates:

- MATLAB-based RF data organization;
- signal-response analysis;
- system-identification workflow;
- neural-network modeling experiments;
- validation across multiple signal classes and RF configurations.

---

## Requirements

- MATLAB
- Signal Processing Toolbox, depending on the scripts used
- Neural Network / Deep Learning functionality, depending on the experiment branch

---

## Author

Michele Abbaticchio  
MSc Automation Engineering  
Politecnico di Bari
