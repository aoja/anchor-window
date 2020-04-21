# Anchor Window

Displays a simple Windows form for selecting the anchoring position of a window. There's a 5 second timer following a click on any of the alignment buttons, after which the window gets snapped into position. I wrote it for fun, and to help me align windows around easier. I'm not a fan of how Windows 10 arranges the docking of windows.

## Usage

First you need to allow PowerShell to execute scripts on your system if you haven't done so. To do this, you need a PowerShell prompt with elevated privileges. Type `powershell` into the Windows taskbar search, and **right click on it**, then select **Run as administrator**.

The UAC prompt will ask you for your consent. Accept and the PowerShell prompt will open.

By default, Windows PowerShell is configured to function in `Restricted`  mode. This means that PowerShell will not load configuration files or run any scripts. You cannot run this script while PowerShell is in *Restricted* mode.

To continue, configure your PowerShell into `Bypass` by typing in the following command:

```
Set-ExecutionPolicy Bypass
```

Now you can execute the scripts in your PowerShell. The script will prompt you for a permission to continue, but the user you run the script on **must have Administrative privileges enabled**. Before committing any changes, the script also offers to generate a System Restore Point for you.

Once you're done, reboot your computer. To restore your PowerShell execution policy back to a safe default, follow the earlier steps and type in the following command to the PowerShell prompt:

```
Set-ExecutionPolicy Restricted
```

Simply run the script, click a button and bring a window to the foreground by clicking it.
