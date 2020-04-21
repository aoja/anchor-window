# MIT License

# Copyright (c) 2020 Antti J. Oja <a.oja@outlook.com>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Using a lot of struff from WinForms.
Add-Type -AssemblyName System.Windows.Forms;

# Import the necessary assemblies and Win32 API calls.
Add-Type @"
using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

public struct RECT
{
    public int left;
    public int top;
    public int right;
    public int bottom;
}

public class Win32API
{
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);

    [DllImport("user32.dll", CharSet = CharSet.Auto, CallingConvention = CallingConvention.StdCall, ExactSpelling = true, SetLastError = true)]
    public static extern bool GetWindowRect(IntPtr hWnd, ref RECT rect);
}
"@;

# Simple function for setting a window's dimensions by handle and parameters.
function Move-Window([System.IntPtr]$WindowHandle, [switch]$Top, [switch]$Bottom, [switch]$Left, [switch]$Right)
{
    # Determine and store the requested window's dimensions.
    $windowRectangle = New-Object RECT;
    [Win32API]::GetWindowRect($WindowHandle, [ref]$windowRectangle);

    # Use the system working area as the screen dimensions.
    $workingArea = [System.Windows.Forms.SystemInformation]::WorkingArea;
    
    if ($Top)
    {
        # If top anchoring is selected, snap to the top of the working area.
        $y = $workingArea.Top;
        $height = $workingArea.Height / 2;
    }
    elseif ($Bottom)
    {
        # If bottom anchoring is selected, snap to the bottom of the working area.
        $y = $workingArea.Bottom / 2;
        $height = $workingArea.Height / 2;
    }
    else
    {
        # If neither top nor bottom snap is selected, snap to the working area top.
        $y = $workingArea.Top;
        $height = $workingArea.Height;
    }

    if ($Left)
    {
        # If left anchoring is selected, snap to the left of the working area.
        $x = $workingArea.Left;
        $width = $workingArea.Width / 2;
    }
    elseif ($Right)
    {
        # If right anchoring is selected, snap to the right of the working area.
        $x = $workingArea.Right / 2;
        $width = $workingArea.Width / 2;
    }
    else
    {
        # If neither left nor right snap is selected, snap to the working area left.
        $x = $workingArea.Left;
        $width = $workingArea.Width;
    }

    # Debug output for the window settings.
    Write-Debug "Setting window to $x $y $width $height";

    # Invoke Win32API for the actual movement.
    [Win32API]::MoveWindow($WindowHandle, $x, $y, $width, $height, $true);
}

# Set up basic dimensions for the form.
$form = New-Object System.Windows.Forms.Form;
$form.Width = 290;
$form.Height = 170;
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle;
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::WindowsDefaultLocation;

# Set up top-left snap button.
$topLeftButton = New-Object System.Windows.Forms.Button;
$topLeftButton.Text = "Top-Left";
$topLeftButton.Width = 85;
$topLeftButton.Height = 25;
$topLeftButton.Top = 5;
$topLeftButton.Left = 5;
$topLeftButton.add_Click(
    {
        # Set help label tell the user to select a window.
        $helpLabel.Text = "Select a window within 5 seconds...";
    
        # Initiate the 5 second sleep timer.
        Start-Sleep -Seconds 5;
    
        # Get the current foreground window handle.
        $handle = [Win32API]::GetForegroundWindow();
    
        # Move the window as requested.
        Move-Window -WindowHandle $handle -Top -Left
    
        # Set help label tell the user that a window was set.
        $helpLabel.Text = "Window docked to top left";
    }
);

# Set up the top snap button.
$topButton = New-Object System.Windows.Forms.Button;
$topButton.Text = "Top";
$topButton.Width = 85;
$topButton.Height = 25;
$topButton.Top = 5;
$topButton.Left = 95;
$topButton.add_Click(
    {
        # Set help label tell the user to select a window.
        $helpLabel.Text = "Select a window within 5 seconds...";
    
        # Initiate the 5 second sleep timer.
        Start-Sleep -Seconds 5;
    
        # Get the current foreground window handle.
        $handle = [Win32API]::GetForegroundWindow();
    
        # Move the window as requested.
        Move-Window -WindowHandle $handle -Top
    
        # Set help label tell the user that a window was set.
        $helpLabel.Text = "Window docked to top";
    }
);

# Set up the top right snap button.
$topRightButton = New-Object System.Windows.Forms.Button;
$topRightButton.Text = "Top-Right";
$topRightButton.Width = 85;
$topRightButton.Height = 25;
$topRightButton.Top = 5;
$topRightButton.Left = 185;
$topRightButton.add_Click(
    {
        # Set help label tell the user to select a window.
        $helpLabel.Text = "Select a window within 5 seconds...";
    
        # Initiate the 5 second sleep timer.
        Start-Sleep -Seconds 5;
    
        # Get the current foreground window handle.
        $handle = [Win32API]::GetForegroundWindow();
    
        # Move the window as requested.
        Move-Window -WindowHandle $handle -Top -Right
    
        # Set help label tell the user that a window was set.
        $helpLabel.Text = "Window docked to top right";
    }
);

# Set up the left snap button.
$leftButton = New-Object System.Windows.Forms.Button;
$leftButton.Text = "Left";
$leftButton.Width = 85;
$leftButton.Height = 25;
$leftButton.Top = 35;
$leftButton.Left = 5;
$leftButton.add_Click(
    {
        # Set help label tell the user to select a window.
        $helpLabel.Text = "Select a window within 5 seconds...";
    
        # Initiate the 5 second sleep timer.
        Start-Sleep -Seconds 5;
    
        # Get the current foreground window handle.
        $handle = [Win32API]::GetForegroundWindow();
    
        # Move the window as requested.
        Move-Window -WindowHandle $handle -Left
    
        # Set help label tell the user that a window was set.
        $helpLabel.Text = "Window docked to left";
    }
);

# Set up the right snap button.
$rightButton = New-Object System.Windows.Forms.Button;
$rightButton.Text = "Right";
$rightButton.Width = 85;
$rightButton.Height = 25;
$rightButton.Top = 35;
$rightButton.Left = 185;
$rightButton.add_Click(
    {
        # Set help label tell the user to select a window.
        $helpLabel.Text = "Select a window within 5 seconds...";
    
        # Initiate the 5 second sleep timer.
        Start-Sleep -Seconds 5;
    
        # Get the current foreground window handle.
        $handle = [Win32API]::GetForegroundWindow();
    
        # Move the window as requested.
        Move-Window -WindowHandle $handle -Right
    
        # Set help label tell the user that a window was set.
        $helpLabel.Text = "Window docked to right";
    }
);

# Set up the bottom left snap button.
$bottomLeftButton = New-Object System.Windows.Forms.Button;
$bottomLeftButton.Text = "Bottom-Left";
$bottomLeftButton.Width = 85;
$bottomLeftButton.Height = 25;
$bottomLeftButton.Top = 65;
$bottomLeftButton.Left = 5;
$bottomLeftButton.add_Click(
    {
        # Set help label tell the user to select a window.
        $helpLabel.Text = "Select a window within 5 seconds...";
    
        # Initiate the 5 second sleep timer.
        Start-Sleep -Seconds 5;
    
        # Get the current foreground window handle.
        $handle = [Win32API]::GetForegroundWindow();
    
        # Move the window as requested.
        Move-Window -WindowHandle $handle -Bottom -Left
    
        # Set help label tell the user that a window was set.
        $helpLabel.Text = "Window docked to bottom left";
    }
);

# Set up the bottom snap button.
$bottomButton = New-Object System.Windows.Forms.Button;
$bottomButton.Text = "Bottom";
$bottomButton.Width = 85;
$bottomButton.Height = 25;
$bottomButton.Top = 65;
$bottomButton.Left = 95;
$bottomButton.add_Click(
    {
        # Set help label tell the user to select a window.
        $helpLabel.Text = "Select a window within 5 seconds...";
    
        # Initiate the 5 second sleep timer.
        Start-Sleep -Seconds 5;
    
        # Get the current foreground window handle.
        $handle = [Win32API]::GetForegroundWindow();
    
        # Move the window as requested.
        Move-Window -WindowHandle $handle -Bottom 
    
        # Set help label tell the user that a window was set.
        $helpLabel.Text = "Window docked to bottom";
    }
);

# Set up the bottom right snap button.
$bottomRightButton = New-Object System.Windows.Forms.Button;
$bottomRightButton.Text = "Bottom-Right";
$bottomRightButton.Width = 85;
$bottomRightButton.Height = 25;
$bottomRightButton.Top = 65;
$bottomRightButton.Left = 185;
$bottomRightButton.add_Click(
    {
        # Set help label tell the user to select a window.
        $helpLabel.Text = "Select a window within 5 seconds...";
    
        # Initiate the 5 second sleep timer.
        Start-Sleep -Seconds 5;
    
        # Get the current foreground window handle.
        $handle = [Win32API]::GetForegroundWindow();
    
        # Move the window as requested.
        Move-Window -WindowHandle $handle -Bottom -Right
    
        # Set help label tell the user that a window was set.
        $helpLabel.Text = "Window docked to bottom right";
    }
);

# Set up the help label.
$helpLabel = New-Object System.Windows.Forms.Label;
$helpLabel.Text = "Select a docking button and click on any window.";
$helpLabel.Width = 265;
$helpLabel.Height = 25;
$helpLabel.Top = 100;
$helpLabel.Left = 5;
$helpLabel.BackColor = [System.Drawing.Color]::Aquamarine;
$helpLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter;
$helpLabel.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D;

# Add the form controls.
$form.Controls.Add($topLeftButton);
$form.Controls.Add($topButton);
$form.Controls.Add($topRightButton);

$form.Controls.Add($leftButton);
$form.Controls.Add($rightButton);

$form.Controls.Add($bottomLeftButton);
$form.Controls.Add($bottomButton);
$form.Controls.Add($bottomRightButton);

$form.Controls.Add($helpLabel);

# Display the dialog.
$form.ShowDialog();
