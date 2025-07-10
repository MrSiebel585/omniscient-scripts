import cv2
import pyautogui
import numpy as np
import time
from datetime import datetime

def find_image_on_screen(template_path, screenshot_count):
    # Load the template image
    template = cv2.imread(template_path, 0)
    template_height, template_width = template.shape[::-1]

    # Take a screenshot of the entire screen
    screenshot = pyautogui.screenshot()
    screenshot = cv2.cvtColor(np.array(screenshot), cv2.COLOR_RGB2BGR)
    screenshot_gray = cv2.cvtColor(screenshot, cv2.COLOR_BGR2GRAY)

    # Find the template image in the screenshot
    res = cv2.matchTemplate(screenshot_gray, template, cv2.TM_CCOEFF_NORMED)
    threshold = 0.8  # Adjust this value based on your needs
    loc = np.where(res >= threshold)

    # Iterate over the locations and draw rectangles around the matches
    for pt in zip(*loc[::-1]):
        cv2.rectangle(screenshot, pt, (pt[0] + template_width, pt[1] + template_height), (0, 255, 0), 2)

    # Generate the filename
    current_date = datetime.now().strftime("%Y%m%d")
    output_path = f"screenshot_{screenshot_count}_{current_date}.png"
    cv2.imwrite(output_path, screenshot)
    return output_path

# Example usage
template_path = "/home/jeremy/Pictures/template.png"
next_page_button_coordinates = (370, 508)  # Adjust these coordinates based on your application
screenshot_count = 0

while True:
    # Increment the screenshot count
    screenshot_count += 1

    # Find the image on the screen
    screenshot_path = find_image_on_screen(template_path, screenshot_count)
    print("Image found! Screenshot saved at:", screenshot_path)

    # Perform actions on the page
    # ...

    # Click the next page button (example action)
    pyautogui.click(next_page_button_coordinates)

    # Wait for the page to load (adjust the sleep time as needed)
    time.sleep(2)

