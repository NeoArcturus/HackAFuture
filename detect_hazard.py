from inference_sdk import InferenceHTTPClient
from PIL import Image
import json
import sys


class RobotHazardDetection:
    def __init__(self):
        self.client = InferenceHTTPClient(
            api_url="https://detect.roboflow.com",
            api_key="i4y45RyymHMfwbAUn88A")

    def detect_fire(self, image):
        results = self.client.infer(
            image, model_id="fire-smoke-detection-eozii/1")
        confidence_level = results["predictions"][0]["confidence"] if results["predictions"] else 0
        positions = {"x": results["predictions"][0]["x"],
                     "y": results["predictions"][0]["y"]} if results["predictions"] else {}
        return {"confidence_level": confidence_level, "positions": positions}

    def detect_crack(self, image):
        results = self.client.infer(image, model_id="crack-data/1")
        confidence_level = results["predictions"][0]["confidence"] if results["predictions"] else 0
        positions = {"x": results["predictions"][0]["x"],
                     "y": results["predictions"][0]["y"]} if results["predictions"] else {}
        return {"confidence_level": confidence_level, "positions": positions}

    def detect_hazard(self, image_path):

        image = Image.open(image_path)

        results = {}
        results["fire_confidence_level"] = self.detect_fire(image)[
            "confidence_level"]
        results["crack_confidence_level"] = self.detect_crack(image)[
            "confidence_level"]
        results["fire_positions"] = self.detect_fire(image)["positions"]
        results["crack_positions"] = self.detect_crack(image)["positions"]

        potential_hazards = []
        if (results["fire_confidence_level"] > 0.5):
            potential_hazards.append("fire risk detected")
        if (results["crack_confidence_level"] > 0.5):
            potential_hazards.append("cracks detected")
        if (results["crack_confidence_level"] > 0.8):
            potential_hazards.append("structure unstable")

        results["detected_hazards"] = potential_hazards

        potential_human_hazard_level = (
            results["fire_confidence_level"] + results["crack_confidence_level"]) / 2

        if (potential_human_hazard_level > 0.75):
            results["hazard_level"] = "very high"
        elif (potential_human_hazard_level > 0.5):
            results["hazard_level"] = "high"
        elif (potential_human_hazard_level > 0.25):
            results["hazard_level"] = "medium"
        else:
            results["hazard_level"] = "low"

        print(results)


if __name__ == "__main__":
    image_path = sys.argv[1]
    robot_hazard_detection = RobotHazardDetection()
    robot_hazard_detection.detect_hazard(image_path=image_path)
