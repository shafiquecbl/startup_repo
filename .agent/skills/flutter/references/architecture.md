# Architecture

## Ownership and structure
- Flow: UI → Controller → Service → Repository → ApiClient.
- Under lib/features/<feature>/: data/model/ (fromJson, toJson, const constructors), data/enum/, data/repository/ (abstract + implementation), domain/binding/, domain/service/ (abstract + implementation), presentation/controller/, presentation/view/ (route screens), presentation/widgets/ (justified extractions).
- Prefer focused feature domains over monoliths. Each model has one owning feature; other features import it rather than duplicate it.
- One public model, enum, command, converter or extension per focused file, except a tightly coupled unit such as a sealed type and its variants.
- Keep boundary conversion beside its boundary, not scattered across controllers/widgets. Extensions stay small/type-local; no hidden I/O, state mutation or business workflows.
- Use role-specific validator/policy/mapper/formatter names; no generic utils/helpers dumps. Add a directory/layer only when it owns behavior or protects a real dependency boundary; no empty future layers.

## Controller and dependency injection
- Controller extends GetxController implements GetxService. It owns UI loading/data/error state, update(), request lifecycle and cleanup.
- Register dependencies with Get.lazyPut; never Get.put. Register the feature binding in core/helper/get_di.dart. Registration enables Get.find(); GetxService is the lifecycle/persistence convention, not registration.
- Split controllers after ~150 lines or 3+ concerns into presentation/mixin/ files, one concern per file; controller remains the orchestrator.
- Mixins never call Get.find(). Resource-owning mixins expose disposeXxx(); controller calls cleanup in onClose().

## Repository, service and errors
- Repository adapts configured infrastructure (e.g. API client/preferences) and returns raw results. Infrastructure types such as ApiResult/ApiRequest are allowed; feature model imports, feature parsing and business logic are not.
- API repositories return sealed, non-nullable ApiResult<Object?>. Success.data is Dio's raw decoded transport body; Failure.error is mapped ApiFailure.
- Service owns feature normalization, request data and success-response parsing. Convert typed inputs to Map<String, dynamic> before calling the repository; unwrap ApiResult and return plain models/values.
- Model? → null means failure/no usable response. List<Model>? → null means failure; [] means successful empty. Mutation bool → true success/false failure.
- Controllers never receive ApiResult, parse raw responses or call repositories directly.
- Backend error parsing → ApiErrorParser under core/api/support/. DioApiClient maps failures once; transport/backend feedback stays centralized in the client.
- Add parser strategies for different backend formats; no raw backend-error parsing or scattered jsonDecode error checks in repositories/services/controllers. Successful response parsing belongs to the service.

## Inputs, models, mappings and endpoints
- Validate all user input in the owning screen/widget before calling the controller. Services must not perform user-input validation.
- One cohesive form/action input is built at UI submission and passed unchanged as the same typed value through UI → controller → service. Service normalizes and converts it for transport.
- Independent ids, page numbers, queries and toggles stay scalars. Pass independent route values directly through constructors. No mechanical parameter-count rule or one-field wrappers.
- Model class names and snake_case filenames omit redundant Model/_model suffixes. API request → XxxRequest with toJson(); response → Xxx with fromJson(); when a genuinely cohesive navigation payload needs a model → XxxRouteParams without serialization.
- Stable UI mapping belongs in enum/model getters, not duplicated widget methods. Feature enums → features/<feature>/data/enum/.
- Literal endpoint paths belong only in Endpoints at core/utils/endpoints.dart; never AppConstants, views, controllers or repositories.

## Loading lifecycle
- Start loading from controller lifecycle or explicit screen entry. Keep data in controller state across ordinary rebuilds/navigation; no accidental refetch. Default-plan selection is controller-owned; UI build must not repeat it or mutate controller state.
- No FutureBuilder for feature/API state or service/repository calls. Retry, refresh, pagination and user actions are explicit controller events.
- Initial failure differs from successful empty. Guard an in-flight load; derive initial loading versus refreshing from whether data exists; reset loading in finally.
- Failed refresh retains existing data. Pagination appends; page failure preserves the list. Keep local mutation state with its action. UI treatment → [Widgets](widgets.md).

## Uploads
- Keep the same service → repository → ApiClient chain.
- Service owns the logical action and normalization. User-selected file limits follow the input-validation ownership above. Repository converts raw fields and paths/bytes into multipart transport; ApiClient sends and returns ApiResult<Object?>.
- Prefer one multipart request for one save action when the backend supports it. Separate upload calls only for the backend contract or an independently retryable media lifecycle.
- No generic UploadService merely because a request contains a file. Repository still accepts raw transport inputs, not feature models.

## Dummy data and API docs
- Dummy data is isolated to previews/catalogs/tests; create it only for requested previews/tests/demos, under data/model/dummy/dummy_<feature>_data.dart.
- Temporary demos use a clearly named demo implementation wired in DI. No commented dummy/real switches or failed production API responses replaced with dummy success.
- Create docs/api/<feature>_api.md only when requested or backend handoff is part of the task; never automatically with ordinary feature work. Response JSON keys must exactly match fromJson().
