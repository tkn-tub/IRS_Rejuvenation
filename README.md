# IRS Rejuvenation
This project develops an intelligent reflective surface (IRS)-assisted link with a mobile user and evaluates the information age.

## Description
This project develops an IRS assisted link between an access point (AP) and a mobile user (MU), where non-line of sight condition is assumed; see the representation in Fig. 1.
The project features the application where the IRS is continously reconfigured to illuminate the MU with a predefined signal-to-noise (SNR) ratio.
The IRS reconfiguration policy is determined with the age of information (AoI) concept; further details are given in paper in [1].

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/IRS_Rejuvenation/blob/main/figures/location.svg?raw=true" alt="nn" width="400">
    </p>
</figure>
<p align="center">
Fig. 1: Illustration of the mobility of the MU and IRS coverage area.
</p>

The AP and the MU implements the WiFi standard 802.11ad in the 60 GHz (mmWave band).
As illustrated in Fig. 2, a the full communication pipeline is integrated for emission, channel propagation through the IRS, and reception (synchronization, demodulation, decoding).
The channel propagation follows a free-space pathloss between the AP and IRS, and also between the IRS and the MU.

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/IRS_Rejuvenation/blob/main/figures/Tx_Rx_scheme.svg?raw=true" alt="nn" width="400">
    </p>
</figure>
<p align="center">
Fig. 2: Block diagram for the implemented transmission-reception scheme according to the 802.11ad.
</p>

The system parameters (accesible in the file `Parameters.mlx`) are given in the following table

| Variable | Description | Value |
| ------------- | ------------- | -------- |
| $\frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$  | 23.2  | |


## Installation
This code is tested in MATLAB 2023b, and the required toolboxes are listed in the table below.

| Matlab Toolbox  | Version |
| ------------- | ------------- |
| Signal Processing  | 23.2  |
| Phased Array System Toolbox  | 23.2  |
|WLAN Toolbox|23.2|

## Usage

This project directly runs from the file `A_Master_File.mlx`, where three main algorithms evaluate:

1- The SNR in the MU plane, see Fig. 3 below.

2- The bit error rate (BER) with the distance from the center of the illuminated area, see Fig. 4.

3- The optimal update period of the IRS to illuminate the MU, see Fig. 5.

Additionally, the following files run the code as described below:

- `Parameters.mlx`: This file evaluates all the parameters for the system model, including the position of the communication components, communication frame slots following the 802.11ad standard, power, and noise levels, and the user's mobility parameters like speed and stop times.

- `IRS_config.mlx`: This code configures the IRS to evaluate a circular illuminated area around the MU; as depicted in Fig. 3.
This code also computes the path loss and the SNR in the link AP-IRS-MU as observed by the MU.

- `IRS_802_11ad.mlx`: This file implements the full communication pipeline in the link AP-IRS-MU as follows from Fig. 2.
This code also evaluates the SNR and the packet error rate (PER) at the MU position.

Besides, within the current directory there are the following folders:

- Folder 802.11ad_functions: This folder contains functions needed to implement the communication pipeline in Fig. 2.
- Folder AoI_functios: This folder contains the code to evaluate the average peak age of information metric (PAoI).
- Folder datasets: This folder contains mat files to store intermediate calculations for the average PAoI function.

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/IRS_Rejuvenation/blob/main/figures/IRS_SNR.svg?raw=true" alt="nn" width="400">
    </p>
</figure>
<p align="center">
Fig. 3: Heat map of the SNR values for the IRS’s illuminated area.
</p>

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/IRS_Rejuvenation/blob/main/figures/BER_802_11_ad_MCS_12.svg?raw=true" alt="nn" width="400">
    </p>
</figure>
<p align="center">
Fig. 4: Average SNR and BER as evaluated along the perimeter of the circle with radius given in the horizontal axis of this plot.
</p>

<figure>
    <p align="center">
        <img src="https://github.com/tkn-tub/IRS_Rejuvenation/blob/main/figures/PAoI.svg?raw=true" alt="nn" width="400">
    </p>
</figure>
<p align="center">
Fig. 5:Average peak age of information PAoI with the IRS update period and various radius for the illuminated area.
</p>

## Features
- **Realistic model for IRS-assisted link in WiFi 802.11ad:** This code evaluates a realistic model for the communication performance with the BER.
- **Implementation of mobility models for users:** This code evaluates the random way point mobility model and includes random speed and stop time.
- **Optimal evaluation of the IRS update period:** This solution evaluates the optimal update period that maximizes the information freshness in the uplink.

## Contributing
Interested contributors can contact the project owner. Please refer to the Contact Information below. We identify further developments for more complex scenarios like estimating the distance to multiple cancer cells.

## License
![Licence](https://img.shields.io/github/license/larymak/Python-project-Scripts)

## Acknowledgements
This work was supported in part by the Federal Ministry of Education and Research (BMBF, Germany) within the 6G Research and Innovation Cluster 6G-RIC under Grant 16KISK020K. Jamali’s work as supported in part by the Deutsche Forschungsgemeinschaft (DFG, German Research Foundation) within the Collaborative Research Center MAKI (SFB 1053, Project-ID 210487104) and in part by the LOEWE initiative (Hesse, Germany) within the emergenCITY center [LOEWE/1/12/519/03/05.001(0016)/72].

## References
<a name="fn1">[1]</a>: Jorge Torres Gómez∗, Joana Angjo∗, Moritz Garkisch†, Vahid Jamali‡, Robert Schober†, and Falko Dressler, “Rejuvenating IRS: AoI-based Low Overhead Reconfiguration Design,” submitted to IEEE TRANSACTION ON WIRELESS COMMUNICATIONS.

## Contact Information

- **Name:** Jorge Torres Gómez

    [![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github)](https://github.com/jorge-torresgomez)

    [![Email](https://img.shields.io/badge/Email-jorge.torresgomez@ieee.org-D14836?logo=gmail&logoColor=white)](mailto:jorge.torresgomez@ieee.org)

    [![LinkedIn](https://img.shields.io/badge/LinkedIn-torresgomez-blue?logo=linkedin&style=flat-square)](https://www.linkedin.com/in/torresgomez/)

    [![Website Badge](https://img.shields.io/badge/Website-Homepage-blue?logo=web)](https://www.tkn.tu-berlin.de/team/torres-gomez/)

- **Name:** Joana Angjo

    [![Email](https://img.shields.io/badge/Email-D14836?logo=gmail&logoColor=white)](mailto:angjo@ccs-labs.org)

    [![Website Badge](https://img.shields.io/badge/Website-Homepage-blue?logo=web)](https://www.tkn.tu-berlin.de/team/angjo/)

 - **Name:** Vahid Jamali 

    [![Email](https://img.shields.io/badge/Email-D14836?logo=gmail&logoColor=white)](mailto:vahid.jamali@tu-darmstadt.de)

    [![Website Badge](https://img.shields.io/badge/Website-Homepage-blue?logo=web)](https://www.etit.tu-darmstadt.de/fachbereich/professuren_etit/etit_prof_details_115264.en.jsp)
    

    

    