import sys
import os

# Add project root to path to import local modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

try:
    from api import logic
    print("Logic module imported successfully.")
    
    inventory = logic.load_inventory()
    if isinstance(inventory, list):
        print(f"Success: Loaded {len(inventory)} items from inventory.json")
        for item in inventory[:2]:
            print(f" - {item.get('name')} in {item.get('country_code')}")
    else:
        print(f"Status: {inventory.get('error')}")
        
    trends = logic.get_trending_items()
    if isinstance(trends, list):
        print(f"Success: Found {len(trends)} trending items.")
    else:
        print(f"Trend Check Status: {trends.get('error')}")

except Exception as e:
    print(f"Verification Failed: {e}")
