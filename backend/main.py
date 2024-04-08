import time

from fastapi import FastAPI, WebSocket
import vgamepad as vg

gamepad = vg.VX360Gamepad()

app = FastAPI()


@app.get("/health")
def health():
    return "ETS2"


def press_and_release(button):
    """
    Simulate pressing of a button
    """

    gamepad.press_button(button=button)
    gamepad.update()
    time.sleep(0.5)
    gamepad.release_button(button=button)
    gamepad.update()


@app.websocket("/ets2")
async def ws(websocket: WebSocket):
    await websocket.accept()
    right_joy_x = 0.0
    right_joy_y = 0.0
    while True:
        data = await websocket.receive_json()
        id = data["id"]

        if id == "quicksave":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_START)
        elif id == "gas":
            gamepad.right_trigger_float(data["val"] / 2 + 0.5)
        elif id == "brake":
            gamepad.left_trigger_float(data["val"] / 2 + 0.5)
        elif id == "gb":
            right_joy_y = data["val"]
        elif id == "steer":
            right_joy_x = data["val"]
        elif id == "gearN":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_B)
        elif id == "gear+":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_X)
        elif id == "gear-":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_Y)
        elif id == "m/a":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_A)
        elif id == "left-turn":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_LEFT)
        elif id == "right-turn":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_RIGHT)
        elif id == "cruise-incr":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_UP)
        elif id == "cruise-decr":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_DPAD_DOWN)
        elif id == "cruise":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_LEFT_THUMB)
        elif id == "cruise-continue":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_RIGHT_THUMB)
        elif id == "parking-brake":
            press_and_release(button=vg.XUSB_BUTTON.XUSB_GAMEPAD_BACK)

        gamepad.right_joystick_float(right_joy_x, right_joy_y)
        gamepad.update()
        print(data)
