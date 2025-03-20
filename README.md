# IRS Rejuvenation
This project develops an intelligent reflective surface (IRS)-assisted link with a mobile user and evaluates the information age.

## Description
This project develops an IRS assisted link between an access point (AP) and a mobile user (MU), where non-line of sight condition is assumed; see the representation in Fig. 1.
The project features the application where the IRS is continously reconfigured to illuminate the MU with a predefined signal-to-noise (SNR) ratio.
The IRS reconfiguration policy is determined with the age of information (AoI) concept; further details are given in paper to be published.

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/figures/location.svg?raw=true" alt="nn" width="500">
    </p>
</figure>
<p align="center">
Fig. 1: Illustration of the mobility of the MU and IRS coverage area.
</p>

The AP and the MU implements the WiFi standard 802.11ad in the 60 GHz (mmWave band).
As illustrated in Fig. 2, a the full communication pipeline is integrated for emission and reception (synchronization, demodulation, decoding).

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/NN_molecular_communications/blob/main/figures/Tx_Rx_scheme.svg?raw=true" alt="nn" width="500">
    </p>
</figure>
<p align="center">
Fig. 2: Block diagram for the implemented transmissionreception scheme according to the 802.11ad.
</p>

## Installation
This code is tested in MATLAB 2023b, and the required toolboxes are listed in the table below.

| Matlab Toolbox  | Version |
| ------------- | ------------- |
| Signal Processing  | 23.2  |
| Phased Array System Toolbox  | 23.2  |
|WLAN Toolbox|23.2|

## Usage

This project directly runs from the file `A_Master_File.mlx`, where three main algorithms evaluates:

1- The SNR in the MU plane, see Fig. 3 below.

2- The bit error rate (BER) with the distance from the center of the illuminated area, see Fig. 4.

3- The optimal update period of the IRS to illuminate the MU, see Fig. 5.

Additionally, the following files run the code described below:

- `Parameters.mlx`: This file evaluates all the parameters for the system model, including the position of the communication components, communication frame slots following the 802.11as standard, power, and noise levels, and the user's mobility.

- `IRS_config,mlx`: This file computes the path loss and the SNR in the link AP-IRS-MU as observed by the MU.

- `IRS_802_11ad.mlx`: This file implements the link AP-IRS-MU and evaluates the SNR at the packet error rate (PER) at the MU position within the 802.11ad std.

Besides, within the current directory there are the following folders:

- Folder 802.11ad_functions: This folder contains the code to implement the communication pipeline in Fig. 2.
- Folder AoI_functios: This folder contains the code to evaluate the average peak age of information metric (PAoI).
- Folder datasets: This folder contains mat files to store intermediate calculations for the average PAoI function.

## Features
- **Realistic model for IRS-assisted link in WiFi 802.11ad:** This code evaluates a realistic model for the communication performance with the BER.
- **Implementation of mobility models for users:** This code evaluates the random way point mobility model and includes random speed and stop time.
- **Optimal evaluation of the IRS update period:** This solution evaluates the optimal update period that maximizes the information freshness in the uplink.

## Contributing
Interested contributors can contact the project owner. Please refer to the Contact Information below. We identify further developments for more complex scenarios like estimating the distance to multiple cancer cells.

## License
![Licence](https://img.shields.io/github/license/larymak/Python-project-Scripts)

## Acknowledgements
We want to acknoledge the support provided by Mohammad Zoofaghari, author of the paper in [1] for giving us the code to generate the dataset.

## References
<a name="fn1">[1]</a>: Jorge Torres Gómez∗, Joana Angjo∗, Moritz Garkisch†, Vahid Jamali‡, Robert Schober†, and Falko Dressler, “Rejuvenating IRS: AoI-based Low Overhead Reconfiguration Design,” submitted to IEEE TRANSACTION ON WIRELESS COMMUNICATIONS.

## Contact Information

- **Name:** Jorge Torres Gómez

    [![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github)](https://github.com/jorge-torresgomez)

    [![Email](https://img.shields.io/badge/Email-jorge.torresgomez@ieee.org-D14836?logo=gmail&logoColor=white)](mailto:jorge.torresgomez@ieee.org)

    [![LinkedIn](https://img.shields.io/badge/LinkedIn-torresgomez-blue?logo=linkedin&style=flat-square)](https://www.linkedin.com/in/torresgomez/)

    [![Website Badge](https://img.shields.io/badge/Website-Homepage-blue?logo=web)](https://www.tkn.tu-berlin.de/team/torres-gomez/)