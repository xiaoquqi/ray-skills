<template>
  <Transition
    enter-active-class="transition duration-200 ease-out"
    enter-from-class="opacity-0"
    enter-to-class="opacity-100"
    leave-active-class="transition duration-150 ease-in"
    leave-from-class="opacity-100"
    leave-to-class="opacity-0"
  >
    <div
      v-if="show"
      class="dialog-overlay"
      aria-modal="true"
      role="dialog"
      @click.self="handleCancel"
    >
      <Transition
        enter-active-class="transition duration-200 ease-out"
        enter-from-class="opacity-0 scale-95"
        enter-to-class="opacity-100 scale-100"
        leave-active-class="transition duration-150 ease-in"
        leave-from-class="opacity-100 scale-100"
        leave-to-class="opacity-0 scale-95"
      >
        <div
          v-if="show"
          class="dialog-panel max-w-md border-b border-border"
          @click.stop
        >
          <div class="dialog-body-inner p-6 pt-6">
            <div class="flex gap-4">
              <div
                v-if="variant === 'danger'"
                class="flex h-11 w-11 flex-shrink-0 items-center justify-center rounded-full bg-red-100 text-red-600"
              >
                <svg
                  class="h-6 w-6"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                  />
                </svg>
              </div>
              <div v-else class="flex h-11 w-11 flex-shrink-0 items-center justify-center rounded-full bg-primary-100 text-primary-600">
                <svg
                  class="h-6 w-6"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
              </div>
              <div class="flex-1 min-w-0">
                <h3
                  v-if="title"
                  class="text-base font-semibold text-gray-900"
                >
                  {{ title }}
                </h3>
                <div class="mt-1 text-sm text-gray-600">
                  <slot>{{ message }}</slot>
                </div>
              </div>
            </div>
          </div>
          <div class="dialog-footer admin-dialog-actions">
            <BaseButton
              :variant="variant"
              size="md"
              :loading="loading"
              @click="$emit('confirm')"
            >
              {{ confirmLabel }}
            </BaseButton>
            <BaseButton
              variant="outline"
              size="md"
              :disabled="loading"
              @click="handleCancel"
            >
              {{ cancelLabel }}
            </BaseButton>
          </div>
        </div>
      </Transition>
    </div>
  </Transition>
</template>

<script setup>
import BaseButton from '@/components/ui/BaseButton.vue'

defineProps({
  show: { type: Boolean, default: false },
  title: { type: String, default: '' },
  message: { type: String, default: '' },
  confirmLabel: { type: String, default: '' },
  cancelLabel: { type: String, default: '' },
  variant: {
    type: String,
    default: 'danger',
    validator: (v) => ['danger', 'primary'].includes(v)
  },
  loading: { type: Boolean, default: false }
})

const emit = defineEmits(['confirm', 'cancel'])

function handleCancel() {
  emit('cancel')
}
</script>
