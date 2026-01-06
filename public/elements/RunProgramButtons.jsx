import React from 'react';
import { Button } from '@/components/ui/button';
import { useContext } from 'react';

const RunProgramButtonsElement = () => {
  const handleClickC64U = () => {
    window.parent.postMessage(
                { command: "start_program_on_c64u", basic_source_code: props.basic_source_code },
                "*"
            );
  }
  const handleClickKungFu = () => {
    window.parent.postMessage(
                { command: "start_program_on_kungfu", basic_source_code: props.basic_source_code },
                "*"
            );
  }
  const handleClickEmulator = () => {
    popupLoaded = false;
    if (Object.hasOwn(window, 'emulator_popup')) {
      if (window.emulator_popup && !window.emulator_popup.closed) {
        window.emulator_popup.focus();
        popupLoaded = true;
      } else {
        window.emulator_popup = window.open(props.target_origin, 'c64_emulator', 'width=1024,height=768');
      }
    } else {
      window.emulator_popup = window.open(props.target_origin, 'c64_emulator', 'width=1024,height=768');
    }
    if (!window.emulator_popup) {
      console.warn('Popup blocked or failed to open.');
      return;
    }

    // Decode the base64 string back to a binary array
    const prgString = atob(props.prg_binary_base64);
    const prgBinaryArray = new Uint8Array(prgString.length);
    for (let i = 0; i < prgString.length; i++) {
        prgBinaryArray[i] = prgString.charCodeAt(i);
    }
    
    const messageArray = prgBinaryArray;

    if (popupLoaded) {
      window.emulator_popup.postMessage(messageArray, "*");
    } else {
      setTimeout(() => {
        window.emulator_popup.postMessage(messageArray, "*");
      }, 4000);
    }
  };

  const buttons = [];

  if (props.showEmulatorButton) {
    buttons.push(
      <Button
        key="emulator"
        onClick={handleClickEmulator}
        className="w-full"
        variant="default"
        size="sm"
      >
        {props.button_label_emulator}
      </Button>
    );
  }

  if (props.showC64UButton) {
    buttons.push(
      <Button
        key="c64u"
        onClick={handleClickC64U}
        className="w-full"
        variant="default"
        size="sm"
      >
        {props.button_label_c64u}
      </Button>
    );
  }

  if (props.showKungFuButton) {
    buttons.push(
      <Button
        key="kungfu"
        onClick={handleClickKungFu}
        className="w-full"
        variant="default"
        size="sm"
      >
        {props.button_label_kungfu}
      </Button>
    );
  }

  if (buttons.length === 0) {
    return null;
  }

  if (buttons.length === 1) {
    return buttons[0];
  }

  return (
    <div className="flex flex-col gap-2">
      {buttons}
    </div>
  );
};

export default RunProgramButtonsElement;
