import { GoogleGenAI } from "@google/genai";

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY || "" });

export async function estimateScrapPrice(base64Image: string) {
  try {
    const response = await ai.models.generateContent({
      model: "gemini-3-flash-preview",
      contents: [
        {
          inlineData: {
            mimeType: "image/jpeg",
            data: base64Image,
          },
        },
        {
          text: `You are an expert scrap recycling estimator for the Bangladesh market. 
          Analyze the image and identify the scrap categories (e.g., Paper/Carton, Plastic, Iron/Steel, Aluminum, Copper).
          Estimate the weight in kg and the current market value in BDT.
          
          Return the result in JSON format:
          {
            "categories": ["Category1", "Category2"],
            "estimatedWeightKg": number,
            "estimatedValueBDT": number,
            "confidence": number,
            "description": "Short description of what was found"
          }`
        },
      ],
      config: {
        responseMimeType: "application/json",
      }
    });

    return JSON.parse(response.text || "{}");
  } catch (error) {
    console.error("Gemini Estimation Error:", error);
    return null;
  }
}
