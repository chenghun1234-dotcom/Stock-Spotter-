import json
import os

def load_inventory():
    """Loads inventory data from inventory.json in the project root."""
    try:
        # Assuming inventory.json is in the root directory relative to 'api'
        root_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        file_path = os.path.join(root_path, "inventory.json")
        
        if not os.path.exists(file_path):
            return {"error": "Inventory data not found", "path": file_path}
            
        with open(file_path, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception as e:
        return {"error": str(e)}

def get_trending_items():
    """Filters inventory for items that are currently trending."""
    data = load_inventory()
    if isinstance(data, list):
        return [item for item in data if item.get("is_trend", False)]
    return data
