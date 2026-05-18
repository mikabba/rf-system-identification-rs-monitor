# RF System Identification with Neural Networks

MATLAB project for RF system identification and signal-response modeling using artificial neural networks.

The project explores the identification of an RF system from measured or simulated responses acquired under different excitation signals and frequency configurations. The implementation focuses on MATLAB-based preprocessing, neural-network modeling and validation.

---

## Project overview

The original experimental structure contains signal datasets organized by excitation type and carrier-frequency configuration. The repository version focuses on the reusable MATLAB code and excludes raw measurement folders to keep the project lightweight and reproducible.

The investigated excitation classes include:

- white noise;
- null signal;
- sweep signal;
- sinusoidal inputs;
- Handel audio signal;
- multiple RF frequency configurations from 25 MHz to 95 MHz.

---

## Engineering objective

The objective is to approximate the behavior of an RF system from input-output observations.

In system-identification terms, the goal is to learn a mapping:

```math
\hat{y}(t) = f_\theta(x(t))
```

where:

- `x(t)` is the input signal or feature vector;
- `y(t)` is the measured system response;
- `f_\theta` is a parametric model learned from data;
- `\hat{y}(t)` is the model-predicted response.

The project investigates artificial neural networks as nonlinear approximators for this mapping.

---

## Repository content

```text
rf-system-identification-rs-monitor/
├── src/
│   └── matlab/
│       ├── ann-scratch/
│       ├── neural-network/
│       └── *.m
├── README.md
└── .gitignore
```

---

## MATLAB implementation

The MATLAB code includes:

| Component | Description |
|---|---|
| `src/matlab/ann-scratch/` | Educational neural-network implementation from scratch |
| `src/matlab/neural-network/` | Object-oriented neural-network prototype |
| `src/matlab/*.m` | Main experiments, validation scripts and data-processing utilities |

The implementation contains code for:

- ANN initialization;
- activation functions and derivatives;
- forward propagation;
- weight and bias updates;
- training routines;
- validation scripts;
- experimental merging and preprocessing.

---

## Dataset policy

Raw measurement folders are intentionally excluded from the repository.

The original local dataset contains repeated measurements organized by signal type and frequency, for example:

```text
Signal class/
├── 25MHz/
├── 35MHz/
├── 45MHz/
├── 55MHz/
├── 65MHz/
├── 75MHz/
├── 85MHz/
└── 95MHz/
```

These datasets are not tracked because they can be large, hardware-specific and not necessary for understanding the code architecture.

---

## Methodology

The identification workflow is:

1. acquire or load RF response data;
2. preprocess and merge experiments;
3. define the neural-network architecture;
4. train the model on available input-output samples;
5. validate the predicted response against measured response;
6. analyze generalization on unseen configurations.

---

## Technical focus

This repository demonstrates:

- MATLAB-based system identification;
- neural-network implementation from scratch;
- nonlinear function approximation;
- RF signal-response modeling;
- experiment organization across multiple frequency configurations;
- validation-oriented engineering workflow.

---

## Requirements

- MATLAB
- Signal Processing Toolbox, depending on the specific scripts used
- Neural Network / Deep Learning functionality, depending on the experiment branch

---

## Notes

This portfolio version focuses on source code and project structure. Raw RF measurements and bibliography PDFs are excluded to keep the repository compact and avoid distributing external copyrighted material.

---

## Author

Michele Abbaticchio  
MSc Automation Engineering  
Politecnico di Bari
