# Purpose

Emulate user's mouse activity on Windows OS.

# Description and justification

<details><summary>How it works (technical details)</summary>
<p>
  At some fixed interval it simulates tiny mouse movement (one pixel diagonal and then back).<br>
  Action is very fast and should ot be noticed by user (hopwever noticed by the operating system).
</p>

<p>
  Diagonal movement is used to handle situation when mouse cursor is at the screen's edge.<br>
  Movement only by 1 pixel only to minimize possible effect to the applications.
</p>
</details>

<details><summary>Why it was created</summary>
Someone asked me to create an application to fool (micro)managers controlling their employees and whethery they become "AFK" during work hours.<br>
<b>This was before the covid pandemy started and people were still working at the office mostly.</b>

Another reason was a dashboard displayed on a "TV" hanging on the wall in some highly<sup>*</sup>-protected office.<br>
Organization allowed only windows machines (except VM's) and enforced screensaver after 5 minutes of no user activity.

<sup>*</sup> This was a financial organization with a concierge, entry door, entry gate,
door/elevator with chip detection (in some places), separate chip-protected door on some floors, high-resolution cameras everywhere
and behind a separate door protected with more locks (and an alarm in case if door were opened too long).
So a "standard" protection for low-to-middle security office.
</details>

<details><summary><b>Why assembler</b></summary>
<ul>
<li>Because I can</li>
<li>Because this is a small task so there is no need to write a large app (like most keyboard/mouse "drivers",
ex. dell alienware control center which is included in the Microsoft Windows and weights over 500MB in the basic version)</li>
<li>Because this is a good example of a small app that people can learn from</li>
<li>Because then it consumes few resources, is small and lightweight</li>
</ul>
</details>

<details><summary>Wouldn't something else work better?</summary>
<p>There are plenty alternatives. Often heavy. Sometimes paid. Some have more features.</p>
<p>You could use auto-hotkey - it is really nice and similar features can be achieved with only a few lines of script</p>
<p>Someone might need a hardware solution</p>
<p>Overall - some other options might work better under some circumstances - it is up to you to make the decision</p>
</details>

# Usage

Just run. Right-click on the tray-icon to enable/disable.

# Change log

- Long time ago - base version
- This readme update
- Upcoming is probably a release package
