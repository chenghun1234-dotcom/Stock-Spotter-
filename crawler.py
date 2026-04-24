import json
import requests
from datetime import datetime

# CONFIGURATION: Add countries you want to track
COUNTRIES = ["KR", "US", "JP"]

def analyze_trend_with_local_ai(product_name, social_text, country_code):
    """Analyze trends using local Ollama instance with country-specific context."""
    url = "http://localhost:11434/api/generate"
    
    prompts = {
        "KR": f"한국 트렌드 분석가로서 '{product_name}'이 현재 한국에서 인기인가요? 응답: True/False",
        "US": f"As a US trend expert, is '{product_name}' trending in the US? Answer: True/False",
        "JP": f"日本のトレンド専門家として、'{product_name}'は流行っていますか？ 応答: True/False"
    }
    
    prompt = prompts.get(country_code, prompts["KR"]) + f"\nContext: {social_text}"
    
    try:
        # Defaulting to llama3 model. Make sure it's installed: `ollama run llama3`
        response = requests.post(url, json={
            "model": "llama3", 
            "prompt": prompt, 
            "stream": False
        }, timeout=60)
        return "True" in response.json().get("response", "")
    except Exception as e:
        print(f"Ollama error for {country_code}: {e}")
        return False

def crawl_global_inventory():
    print(f"Starting Global Inventory Crawl... {datetime.now()}")
    final_data = []
    
    for country in COUNTRIES:
        print(f"Processing data for {country}...")
        
        # MOCKED DATA: Replace these with actual scraping logic per country
        items_by_country = {
            "KR": {"name": "황치즈 생크림빵", "store": "GS25 강남역점", "social": "황치즈 대란.. 진짜 맛있음!"},
            "US": {"name": "Viral Takis", "store": "CVS Times Square", "social": "Everyone is trying the new Blue Takis!"},
            "JP": {"name": "Matcha Mochi", "store": "Lawson Shinjuku", "social": "LAWSONの抹茶モチがトレンド入り！"}
        }

        target = items_by_country.get(country, items_by_country["KR"])
        
        is_trend = analyze_trend_with_local_ai(target["name"], target["social"], country)
        
        item = {
            "id": f"{country}_item_001",
            "name": target["name"],
            "store_name": target["store"],
            "country_code": country,
            "latitude": 37.4979, # Placeholder
            "longitude": 127.0276, # Placeholder
            "quantity": 10,
            "is_trend": is_trend,
            "updated_at": datetime.now().isoformat()
        }
        final_data.append(item)

    with open("inventory.json", "w", encoding="utf-8") as f:
        json.dump(final_data, f, ensure_ascii=False, indent=2)
    
    print(f"Global sync complete. Saved to inventory.json")

if __name__ == "__main__":
    crawl_global_inventory()
