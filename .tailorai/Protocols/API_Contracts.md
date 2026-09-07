# API Contracts & Response Conventions — tsbeh (Flutter Tasbeeh Al Muslim)

## 1. Remote API Response Envelope
The application consumes JSON endpoints hosted at `https://api.4topapps.com/APPS/tsbeh/v3/` structured around standard response envelopes handled by `Apis.dart` and `ApiResponse.dart`:

### Success Response Envelope
```json
{
  "status": 1,
  "message": "Success",
  "data": [
    {
      "id": "1",
      "title": "سورة الفاتحة",
      "url": "https://server.mp3quran.net/...",
      "reciter": "مشاري العفاسي"
    }
  ]
}
```

### Error Response Envelope
```json
{
  "status": 0,
  "message": "عفواً، تعذر تحميل البيانات، يرجى التحقق من اتصال الإنترنت"
}
```

## 2. HTTP Status Codes Protocol
- `200 OK`: Data successfully fetched and decoded into `ApiModel` objects.
- `404 Not Found`: Remote resource or audio stream unavailable.
- `500+ Server Error`: Remote server error; application defaults gracefully to cached local data via `CashLocal`.

## 3. Pagination & Query Conventions
- Pagination parameter: `?page={page_number}` passed via `Apis.getList()`.
- Incremental loading handled via `incrementally_loading_listview.dart`.
