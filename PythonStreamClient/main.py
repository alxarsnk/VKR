from tkinter import *
from PIL import Image, ImageTk
import cv2
from PIL.Image import Resampling
import urllib.request

root = Tk()
root.title("Video")

openbtn = Button(root, text='Open', command=lambda: some())
openbtn.pack(side=TOP, pady=2)

horiz_frame=Frame(root,height=20,width=200)
horiz_frame.pack_propagate(0)
horiz_frame.pack(side=TOP, padx=4)

text_box = Text(horiz_frame, wrap='word',bg="#282828",fg="white",bd=0,height=100,width=100)
text_box.pack()

cap = cv2.VideoCapture(0)

def some():
    global cap
    url = text_box.get("1.0", "end-1c")
    cap = cv2.VideoCapture(url)

    if not cap.isOpened():
        cap.release()
        return
    else:
        update()

def update():

    ret, img = cap.read()
    if ret:
        cv2image = cv2.cvtColor(cap.read()[1], cv2.COLOR_BGR2RGB)
        img = Image.fromarray(cv2image).resize((360, 720), Resampling.LANCZOS)

        # Convert image to PhotoImage
        imgtk = ImageTk.PhotoImage(image=img)
        canvas.create_image(0, 0, image=imgtk, anchor=NW)
        canvas.image = imgtk
    else:
        cap.release()
        canvas.delete("all")
        return
    root.after(1, update)



canvas = Canvas(root, width=360, height=700)
canvas.pack()

root.mainloop()
cap.release()