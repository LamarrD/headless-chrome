from headless_chrome import create_driver
from selenium.webdriver.common.by import By

def lambda_handler(event, context):
    """ Sample handler using imported the layer """
    driver = create_driver()
    driver.get("https://example.com/")
    heading = driver.find_element(By.TAG_NAME, 'h1')
    return heading.text