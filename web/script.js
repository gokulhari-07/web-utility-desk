// This file exposes browser APIs through small JS functions.
// Dart calls these functions via JS interop bindings in `lib/js_bindings.dart`.

(() => {
  let networkCallback = null;
  let onlineListener = null;
  let offlineListener = null;

  let speechRecognition = null;
  let speechResultCallback = null;
  let speechStateCallback = null;
  let speechIsActive = false;

  function buildResult(success, message, value = "") {
    return JSON.stringify({
      success,
      message,
      value,
      timestamp: new Date().toISOString(),
    });
  }

  function getErrorMessage(error) {
    if (error && typeof error === "object" && "message" in error) {
      return String(error.message);
    }
    return String(error ?? "Unknown error");
  }

  function getSpeechRecognitionConstructor() {
    return window.SpeechRecognition || window.webkitSpeechRecognition || null;
  }

  function emitSpeechState(status, message) {
    if (typeof speechStateCallback !== "function") {
      return;
    }

    speechStateCallback(
      JSON.stringify({
        status,
        message,
        timestamp: new Date().toISOString(),
      })
    );
  }

  function emitSpeechResult(transcript, isFinal) {
    if (typeof speechResultCallback !== "function") {
      return;
    }

    speechResultCallback(
      JSON.stringify({
        transcript,
        isFinal,
        timestamp: new Date().toISOString(),
      })
    );
  }

  function configureSpeechRecognition(locale) {
    const SpeechRecognitionClass = getSpeechRecognitionConstructor();
    if (!SpeechRecognitionClass) {
      return null;
    }

    if (!speechRecognition) {
      speechRecognition = new SpeechRecognitionClass();
    }

    speechRecognition.lang =
      locale && locale.trim() ? locale.trim() : "en-US";
    speechRecognition.interimResults = true;
    speechRecognition.continuous = true;
    speechRecognition.maxAlternatives = 1;

    speechRecognition.onstart = () => {
      speechIsActive = true;
      emitSpeechState("listening", "Microphone listening started.");
    };

    // Streams transcripts back to Dart whenever the browser emits results.
    speechRecognition.onresult = (event) => {
      for (let i = event.resultIndex; i < event.results.length; i += 1) {
        const result = event.results[i];
        if (!result || !result[0]) {
          continue;
        }

        const transcript = (result[0].transcript ?? "").trim();
        if (!transcript) {
          continue;
        }

        emitSpeechResult(transcript, result.isFinal === true);
      }
    };

    speechRecognition.onerror = (event) => {
      const errorLabel = event && event.error ? String(event.error) : "unknown";
      emitSpeechState("error", `Speech error: ${errorLabel}`);
    };

    speechRecognition.onend = () => {
      speechIsActive = false;
      emitSpeechState("stopped", "Speech recognition stopped.");
    };

    return speechRecognition;
  }

  // Feature detection: lets Dart show what is supported in this browser.
  window.getApiSupportJson = function () {
    const support = {
      clipboard:
        typeof navigator !== "undefined" &&
        !!navigator.clipboard &&
        typeof navigator.clipboard.writeText === "function" &&
        typeof navigator.clipboard.readText === "function",
      notifications: typeof Notification !== "undefined",
      speechRecognition: !!getSpeechRecognitionConstructor(),
      network:
        typeof window !== "undefined" &&
        typeof window.addEventListener === "function" &&
        typeof navigator !== "undefined" &&
        "onLine" in navigator,
    };

    return JSON.stringify(support);
  };

  // Promise-based API example: clipboard write.
  window.copyTextToClipboard = async function (text) {
    if (
      !navigator.clipboard ||
      typeof navigator.clipboard.writeText !== "function"
    ) {
      return buildResult(false, "Clipboard API not supported.");
    }

    try {
      await navigator.clipboard.writeText(text);
      return buildResult(true, "Copied to clipboard.", text);
    } catch (error) {
      return buildResult(false, `Copy failed: ${getErrorMessage(error)}`);
    }
  };

  // Promise-based API example: clipboard read.
  window.readClipboardText = async function () {
    if (
      !navigator.clipboard ||
      typeof navigator.clipboard.readText !== "function"
    ) {
      return buildResult(false, "Clipboard API not supported.");
    }

    try {
      const value = await navigator.clipboard.readText();
      return buildResult(true, "Clipboard text loaded.", value);
    } catch (error) {
      return buildResult(false, `Read failed: ${getErrorMessage(error)}`);
    }
  };

  // Notification permission flow (Promise API).
  window.requestNotificationPermission = async function () {
    if (typeof Notification === "undefined") {
      return buildResult(false, "Notifications are not supported.");
    }

    try {
      const permission = await Notification.requestPermission();
      return buildResult(true, `Permission: ${permission}.`, permission);
    } catch (error) {
      return buildResult(
        false,
        `Permission request failed: ${getErrorMessage(error)}`
      );
    }
  };

  // Notification constructor example.
  window.sendBrowserNotification = function (title, body) {
    if (typeof Notification === "undefined") {
      return buildResult(false, "Notifications are not supported.");
    }

    if (Notification.permission !== "granted") {
      return buildResult(false, "Notification permission is not granted.");
    }

    try {
      const safeTitle = title && title.trim() ? title : "Web Utility Desk";
      const safeBody = body && body.trim() ? body : "JS interop notification.";
      new Notification(safeTitle, { body: safeBody });
      return buildResult(true, "Notification sent.");
    } catch (error) {
      return buildResult(
        false,
        `Notification failed: ${getErrorMessage(error)}`
      );
    }
  };

  window.registerSpeechRecognitionCallbacks = function (
    onResultCallback,
    onStateCallback
  ) {
    speechResultCallback = onResultCallback;
    speechStateCallback = onStateCallback;
  };

  window.unregisterSpeechRecognitionCallbacks = function () {
    speechResultCallback = null;
    speechStateCallback = null;
  };

  // Starts browser speech recognition.
  window.startSpeechRecognition = function (locale) {
    const recognition = configureSpeechRecognition(locale);

    if (!recognition) {
      return buildResult(false, "Speech Recognition API is not supported.");
    }

    if (speechIsActive) {
      return buildResult(false, "Speech recognition is already active.");
    }

    try {
      recognition.start();
      return buildResult(true, "Starting microphone listener...");
    } catch (error) {
      return buildResult(false, `Speech start failed: ${getErrorMessage(error)}`);
    }
  };

  // Stops browser speech recognition.
  window.stopSpeechRecognition = function () {
    if (!speechRecognition || !speechIsActive) {
      return buildResult(false, "Speech recognition is not active.");
    }

    try {
      speechRecognition.stop();
      return buildResult(true, "Stopping microphone listener...");
    } catch (error) {
      return buildResult(false, `Speech stop failed: ${getErrorMessage(error)}`);
    }
  };

  window.isSpeechRecognitionActive = function () {
    return speechIsActive;
  };

  // Simple status snapshot.
  window.getOnlineStatus = function () {
    return navigator.onLine;
  };

  // Event-based interop example: JS events calling back into Dart.
  window.registerNetworkListener = function (callback) {
    networkCallback = callback;

    const emit = (isOnline) => {
      if (typeof networkCallback === "function") {
        networkCallback(isOnline);
      }
    };

    if (!onlineListener) {
      onlineListener = () => emit(true);
      window.addEventListener("online", onlineListener);
    }

    if (!offlineListener) {
      offlineListener = () => emit(false);
      window.addEventListener("offline", offlineListener);
    }

    emit(navigator.onLine);
  };

  window.unregisterNetworkListener = function () {
    if (onlineListener) {
      window.removeEventListener("online", onlineListener);
      onlineListener = null;
    }

    if (offlineListener) {
      window.removeEventListener("offline", offlineListener);
      offlineListener = null;
    }

    networkCallback = null;
  };
})();
