import LLM "mo:llm";
import Array "mo:base/Array";
import Http "mo:base/Http";  // ✅ Import HTTP module
import Text "mo:base/Text";  // ✅ Import Text module

persistent actor {
  public func prompt(prompt : Text) : async Text {
    await LLM.prompt(#Llama3_1_8B, prompt);
  };

  public func chat(messages : [LLM.ChatMessage]) : async Text {
    let chatHistory : [LLM.ChatMessage] = Array.append(
      [{ role = #system_; content = "You are an AI specialized in marine conservation and ocean sustainability." }],
      messages
    );

    let response = await LLM.chat(#Llama3_1_8B, chatHistory);
    return response;
  };

  // ✅ NEW FUNCTION: Fetch Real-Time Marine Data
  public func getRealTimeMarineData() : async Text {
    let url = "https://api.oceandrivers.com:443/v1.0/getWeather";  // Replace with a real marine data API

    let request : Http.Request = {
      url = url;
      method = #get;
      headers = [];
      body = null;
    };

    let response = await Http.fetch(request);
    
    switch (response.status) {
      case (200) {
        switch (response.body) {
          case (?body) {
            return "Marine Data: " # Text.decodeUtf8(body);
          };
          case (null) {
            return "No response body found.";
          };
        };
      };
      case (_) { return "Failed to fetch marine data."; };
    };
  };
};
