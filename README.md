Project: Advanced Peripheral Control for Mekanism and AE2 Systems

This repository contains a collection of Lua scripts designed to control various peripherals in Minecraft modded environments, specifically for Applied Energistics 2 (AE2) and Mekanism. The scripts are compatible with the ComputerCraft mod and provide robust functionality for managing fission reactors, induction matrices, AE2 storage systems, and Mekanism digital miners.
Features
1. AE2 Display (ae2display.lua)

    Displays AE2 storage capacity and energy usage on a monitor.
    Dynamically updates the screen with:
        Current time.
        Used and total storage.
        Storage percentage visualized with a progress bar.
        Current energy usage in FE/t.

2. Centrifuge Processing (extra_fast_comb_processing.lua)

    Automates the processing of items through multiple centrifuges.
    Balances:
        Input distribution.
        Fluid dumping.
        Output item handling.

3. Fission Reactor Control (fission.lua)

    Monitors and controls up to 8 Mekanism Fission Reactors and turbines.
    Displays real-time data such as:
        Reactor status, temperature, damage, fuel, and coolant levels.
        Waste and heated coolant levels.
        Turbine energy production and flow rate.
    Provides manual control for toggling reactors on/off via monitor interaction.

4. Induction Matrix Monitoring (matrix.lua)

    Displays Mekanism Induction Matrix data on a monitor.
    Tracks:
        Energy stored and percentage.
        Input/output rates and transfer efficiency.
        Time until the matrix is fully charged, calculated dynamically.

5. Mekanism Miner Notification System
Notifier (mekanism-miner-notifier.lua):

    A modem listener that displays miner activity logs.

Miner Script (mekanism_miner.lua):

    Automates Mekanism Digital Miner setup, operation, and teardown.
    Configures filters dynamically and logs progress using the notifier.

6. Function Library (functions.lua)

    Reusable utility functions for:
        Number formatting with suffixes (e.g., K, M, G).
        Unit conversions (Kelvin to Celsius, etc.).
        Progress bar calculations and centering text on monitors.
        Table manipulation and other common tasks.

7. Multi-Process Runner (run.lua)

    Runs both fission reactor and induction matrix monitoring scripts simultaneously.

Installation

    Install ComputerCraft or its forks like CC: Tweaked in your Minecraft modpack.
    Clone this repository to your computer.
    Copy the files to your in-game computer using:
        pastebin (use pastebin put) or similar tools (e.g., wget with custom URLs).
        Use network sharing if available (e.g., with wget or custom HTTP servers).

How to Use
AE2 Display

    Connect a monitor and environmental detector to your computer.
    Update the peripheral names (left, monitor_2, environmentDetector_0) in the script to match your setup.
    Run ae2display.lua on the computer.

Centrifuge Processing

    Configure your centrifuges and input/output storage systems.
    Update the script with correct peripheral names.
    Run extra_fast_comb_processing.lua to begin automated item processing.

Fission Reactor Control

    Connect reactors, turbines, redstone integrators, and monitors to your computer.
    Update the script with the peripheral names.
    Run fission.lua to monitor and control reactors in real-time.

Induction Matrix Monitoring

    Connect the induction port and monitor to your computer.
    Update the script with the correct peripheral names.
    Run matrix.lua to start monitoring.

Mekanism Miner

    Ensure the miner and turtle peripherals are properly connected.
    Use mekanism-miner-notifier.lua on a separate computer to listen for miner updates.
    Run mekanism_miner.lua with appropriate arguments (e.g., tag and quantity to mine).

File Descriptions
File Name	Description
ae2display.lua	AE2 storage monitor script.
extra_fast_comb_processing.lua	Automated centrifuge management.
fission.lua	Fission reactor and turbine monitoring/control.
functions.lua	Utility functions shared across scripts.
matrix.lua	Induction matrix monitoring.
mekanism-miner-notifier.lua	Notifier for miner activity logs.
mekanism_miner.lua	Automates setup and operation of a Mekanism miner.
run.lua	Multi-script runner for simultaneous monitoring.
Requirements

    Minecraft Mods:
        ComputerCraft.
        Mekanism.
        Applied Energistics 2.

    Peripherals:
        Monitors.
        Environmental detectors.
        Induction ports.
        Digital miners.
        Redstone integrators.

Contribution

    Fork the repository.
    Create a new branch for your feature/fix.
    Commit your changes and submit a pull request.

License

This project is licensed under the MIT License. See the LICENSE file for more details.
